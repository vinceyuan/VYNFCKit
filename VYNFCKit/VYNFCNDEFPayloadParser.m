//
//  VYNFCNDEFPayloadParser.m
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "VYNFCNDEFPayloadParser.h"
#import <CoreNFC/CoreNFC.h>
#import "VYNFCNDEFPayloadTypes.h"
#import "VYNFCNDEFMessageHeader.h"

uint16_t uint16FromBigEndian(unsigned char*p);

@implementation VYNFCNDEFPayloadParser

+ (nullable id)parse:(nullable NFCNDEFPayload *)payload {
    if (!payload) {
        return nil;
    }

    NSString *typeString = [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding];
    NSString *identifierString = [[NSString alloc] initWithData:payload.identifier encoding:NSUTF8StringEncoding];
    NSUInteger payloadBytesLength = [payload.payload length];
    unsigned char *payloadBytes = (unsigned char*)[payload.payload bytes];
    if (!typeString || !identifierString || !payloadBytes) {
        return nil;
    }

    if (payload.typeNameFormat == NFCTypeNameFormatNFCWellKnown) {
        if ([typeString isEqualToString:@"T"]) {
            return [VYNFCNDEFPayloadParser parseTextPayload:payloadBytes length:payloadBytesLength];
        } else if ([typeString isEqualToString:@"U"]) {
            return [VYNFCNDEFPayloadParser parseURIPayload:payloadBytes length:payloadBytesLength];
        } else if([typeString isEqualToString:@"Sp"]) {
            return [VYNFCNDEFPayloadParser parseSmartPosterPayload:payloadBytes length:payloadBytesLength];
        }
    } else if (payload.typeNameFormat == NFCTypeNameFormatMedia) {
        if ([typeString isEqualToString:@"text/x-vCard"]) {
            return [VYNFCNDEFPayloadParser parseTextXVCardPayload:payloadBytes length:payloadBytesLength];
        } else if ([typeString isEqualToString:@"application/vnd.wfa.wsc"]) {
            return [VYNFCNDEFPayloadParser parseWifiSimpleConfigPayload:payloadBytes length:payloadBytesLength];
        }
    }
    return nil;
}

# pragma mark - Parse Well Known Type

// |------------------------------|
// | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0|
// |------------------------------|
// |UTF| 0 | Length of Lang Code  |  1 byte Text Record Status Byte
// |------------------------------|
// |          Lang Code           |  2 or 5 bytes, multi-byte language code
// |------------------------------|
// |             Text             |  Multiple Bytes encoded in UTF-8 or UTF-16
// |------------------------------|
// Text Record Status Byte: size = 1 byte: specifies the encoding type (UTF8 or UTF16) and the length of the language code
//   UTF : 0=UTF8, 1=UTF16
//   Bit6 : bit 6 is reserved for future use and must always be 0
//   Bit5-0: Length Language Code: specifies the size of the Lang Code field in bytes
// Lang Code : size = 2 or 5 bytes (may vary in future) : this is the langauge code for the document(ISO/IANA), common codes are ‘en’ for english, ‘en-US’ for United States English, ‘jp’ for japanese, … etc
// Text : size = remainder of Payload Size : this is the area that contains the text, the format and language are known from the UTF bit and the Lang Code.
//
// Example: "\2enThis is text.", "\2cn你好hello"
+ (nullable id)parseTextPayload:(unsigned char* )payloadBytes length:(NSUInteger)length {
    if (length < 1) {
        return nil;
    }

    // Parse first byte Text Record Status Byte.
    BOOL isUTF16 = payloadBytes[0] & 0x80;
    uint8_t codeLength = payloadBytes[0] & 0x7F;

    if (length < 1 + codeLength) {
        return nil;
    }

    // Get lang code and text.
    NSString *langCode = [[NSString alloc] initWithBytes:payloadBytes + 1 length:codeLength encoding:NSUTF8StringEncoding];
    NSString *text = [[NSString alloc] initWithBytes:payloadBytes + 1 + codeLength
                                              length:length - 1 - codeLength
                                            encoding: (!isUTF16)?NSUTF8StringEncoding:NSUTF16StringEncoding];
    if (!langCode || !text) {
        return nil;
    }
    VYNFCNDEFTextPayload *payload = [VYNFCNDEFTextPayload new];
    payload.isUTF16 = isUTF16;
    payload.langCode = langCode;
    payload.text = text;
    return payload;
}

// |------------------------------|
// |         ID Code              |  1 byte ID Code
// |------------------------------|
// |      UTF-8 String            |  Multiple Bytes UTF-8 string
// |------------------------------|
// Example: "\4example.com" stands for "https://example.com"
+ (nullable id)parseURIPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
    if (length < 1) {
        return nil;
    }

    // Get ID code and original text.
    const uint8_t code = (const uint8_t)payloadBytes[0];
    NSString *originalText = [[NSString alloc] initWithBytes:payloadBytes + 1 length:length - 1 encoding:NSUTF8StringEncoding];
    if (!originalText) {
        return nil;
    }

    // Add prefix according to ID code.
    VYNFCNDEFURIPayload *payload = [VYNFCNDEFURIPayload new];
    NSString *text;
    switch (code) {
        case 0x00: // N/A. No prepending is done
            text = originalText; break;
        case 0x01: // http://www.
            text = [@"http://www." stringByAppendingString:originalText]; break;
        case 0x02: // https://www.
            text = [@"https://www." stringByAppendingString:originalText]; break;
        case 0x03: // http://
            text = [@"http://" stringByAppendingString:originalText]; break;
        case 0x04: // https://
            text = [@"https://" stringByAppendingString:originalText]; break;
        case 0x05: // tel:
            text = [@"tel:" stringByAppendingString:originalText]; break;
        case 0x06: // mailto:
            text = [@"mailto:" stringByAppendingString:originalText]; break;
        case 0x07: // ftp://anonymous:anonymous@
            text = [@"ftp://anonymous:anonymous@" stringByAppendingString:originalText]; break;
        case 0x08: // ftp://ftp.
            text = [@"ftp://ftp." stringByAppendingString:originalText]; break;
        case 0x09: // ftps://
            text = [@"ftps://" stringByAppendingString:originalText]; break;
        case 0x0A: // sftp://
            text = [@"sftp://" stringByAppendingString:originalText]; break;
        case 0x0B: // smb://
            text = [@"smb://" stringByAppendingString:originalText]; break;
        case 0x0C: // nfs://
            text = [@"nfs://" stringByAppendingString:originalText]; break;
        case 0x0D: // ftp://
            text = [@"ftp://" stringByAppendingString:originalText]; break;
        case 0x0E: // dav://
            text = [@"dav://" stringByAppendingString:originalText]; break;
        case 0x0F: // news:
            text = [@"news:" stringByAppendingString:originalText]; break;
        case 0x10: // telnet://
            text = [@"telnet://" stringByAppendingString:originalText]; break;
        case 0x11: // imap:
            text = [@"imap:" stringByAppendingString:originalText]; break;
        case 0x12: // rtsp://
            text = [@"rtsp://" stringByAppendingString:originalText]; break;
        case 0x13: // urn:
            text = [@"urn:" stringByAppendingString:originalText]; break;
        case 0x14: // pop:
            text = [@"pop:" stringByAppendingString:originalText]; break;
        case 0x15: // sip:
            text = [@"sip:" stringByAppendingString:originalText]; break;
        case 0x16: // sips:
            text = [@"sips:" stringByAppendingString:originalText]; break;
        case 0x17: // tftp:
            text = [@"tftp:" stringByAppendingString:originalText]; break;
        case 0x18: // btspp://
            text = [@"btspp://" stringByAppendingString:originalText]; break;
        case 0x19: // btl2cap://
            text = [@"btl2cap://" stringByAppendingString:originalText]; break;
        case 0x1A: // btgoep://
            text = [@"btgoep://" stringByAppendingString:originalText]; break;
        case 0x1B: // tcpobex://
            text = [@"tcpobex://" stringByAppendingString:originalText]; break;
        case 0x1C: // irdaobex://
            text = [@"irdaobex://" stringByAppendingString:originalText]; break;
        case 0x1D: // file://
            text = [@"file://" stringByAppendingString:originalText]; break;
        case 0x1E: // urn:epc:id:
            text = [@"urn:epc:id:" stringByAppendingString:originalText]; break;
        case 0x1F: // urn:epc:tag:
            text = [@"urn:epc:tag:" stringByAppendingString:originalText]; break;
        case 0x20: // urn:epc:pat:
            text = [@"urn:epc:pat:" stringByAppendingString:originalText]; break;
        case 0x21: // urn:epc:raw:
            text = [@"urn:epc:raw:" stringByAppendingString:originalText]; break;
        case 0x22: // urn:epc:
            text = [@"urn:epc:" stringByAppendingString:originalText]; break;
        case 0x23: // urn:nfc:
            text = [@"urn:nfc:" stringByAppendingString:originalText]; break;
        default: // 0x24-0xFF RFU Reserved for Future Use, Not Valid Inputs
            return nil;
    }
    payload.URIString = text;
    return payload;
}

// Smart Poster Record (‘Sp’) Payload Layout:
// A smart poster is a special kind of NDEF Message, it is a wrapper for other message types. Smart Poster records were
// initially meant to be used as a hub for information, think put a smart poster tag on a movie poster and it will give
// you a title for the tag, a link to the movie website, a small image for the movie and maybe some other data. In
// practice Smart Posters are rarely used, most people prefer to simply use a URI record to send people off to do stuff
// (the majority of Google Android NFC messages are implemented this way with custom TNF tags).
// A smart poster must contain:
//  1+ Text records (there can be multiple in multiple languages)
//  1 URI record (this is the main record, everything else is metadata
//  1 Action Record – Specifies Action to do on URI, (Open, Save, Edit)
// A smart poster may optionally contain:
//  1+ Icon Records – MIME type image record
//  a size record – used to tell how large referenced external entity is (ie size of pdf or mp3 the URI points to)
//  a type record – declares Mime type of external entity
//  Multiple other record types (it literally can be anything you want)
// There is no special layout for a Smart Poster record type, the Message Payload is just a series of other messages.
// You know you have reached the end of a smart poster when you have read in a number of bytes = Payload Length. This is
// also how you distinguish sub-messages from each other, a whole lot of basic math.
//  ______________________________
// |       Message Header         |
// |         Type = 'Sp'          |
// |------------------------------|
// |       Message Payload        |
// |    ______________________    |
// |   | sub-message1 header  |   | Could be a Text Record
// |   |----------------------|   |
// |   | sub-message1 payload |   |
// |   |----------------------|   |
// |                              |
// |    ______________________    |
// |   | sub-message2 header  |   | Could be a URI record
// |   |----------------------|   |
// |   | sub-message2 payload |   |
// |   |----------------------|   |
// |                              |
// |    ______________________    |
// |   | sub-message3 header  |   | Could be an Action record
// |   |----------------------|   |
// |   | sub-message3 payload |   |
// |   |----------------------|   |
// |                              |
// |------------------------------|
+ (nullable id)parseSmartPosterPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
    VYNFCNDEFSmartPosterPayload *smartPoster = [VYNFCNDEFSmartPosterPayload new];

    NSMutableArray *payloadTexts = [[NSMutableArray alloc] init];
    VYNFCNDEFMessageHeader *header = nil;
    while ((header = [VYNFCNDEFPayloadParser parseMessageHeader:payloadBytes length:length])) {
        length -= header.payloadOffset;
        payloadBytes += header.payloadOffset;
        if ([header.type isEqualToString:@"U"]) {
            // Parse URI payload.
            id parsedPayload = [VYNFCNDEFPayloadParser parseURIPayload:payloadBytes length:header.payloadLength];
            if (!parsedPayload) {
                return nil;
            }
            smartPoster.payloadURI = parsedPayload;

        } else if ([header.type isEqualToString:@"T"]) {
            // Parse text payload.
            id parsedPayload = [VYNFCNDEFPayloadParser parseTextPayload:payloadBytes length:header.payloadLength];
            if (!parsedPayload) {
                return nil;
            }
            [payloadTexts addObject:parsedPayload];

        } else {
            // Currently other records are not supported.
            return nil;
        }
        length -= header.payloadLength;
        payloadBytes += header.payloadLength;
        if (header.isMessageEnd || length == 0) {
            break;
        }
    }
    // Must have at least one text load.
    if ([payloadTexts count] == 0) {
        return nil;
    }
    smartPoster.payloadTexts = payloadTexts;
    return smartPoster;
}

// The fields in an NDEF Message header are as follows:
//  ______________________________
// | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0|
// |------------------------------|
// | MB| ME| CF| SR| IL|    TNF   |  NDEF StatusByte, 1 byte
// |------------------------------|
// |        TYPE_LENGTH           |  1 byte, hex value
// |------------------------------|
// |        PAYLOAD_LENGTH        |  1 or 4 bytes (determined by SR) (LSB first)
// |------------------------------|
// |        ID_LENGTH             |  0 or 1 bytes (determined by IL)
// |------------------------------|
// |        TYPE                  |  2 or 5 bytes (determined by TYPE_LENGTH)
// |------------------------------|
// |        ID                    |  0 or 1 byte  (determined by IL & ID_LENGTH) (Note by vince: maybe it could be longer.)
// |------------------------------|
// |        PAYLOAD               |  X bytes (determined by PAYLOAD_LENGTH)
// |------------------------------|
// NDEF Status Byte : size = 1byte : has multiple bit fields that contain meta data bout the rest of the header fields.
//  MB : Message Begin flag
//  ME : Message End flag
//  CF : Chunk Flag (1 = Record is chunked up across multiple messages)
//  SR : Short Record flag ( 1 = Record is contained in 1 message)
//  IL : ID Length present flag ( 0 = ID field not present, 1 = present)
//  TNF: Type Name Format code – one of the following
//      0x00 : Empty
//      0x01 : NFC Well Known Type [NFC RTD] (Use This One)
//      0x02 : Media Type [RFC 2046]
//      0x03 : Absolute URI [RFC 3986]
//      0x04 : External Type [NFC RTD]
//      0x05 : UnKnown
//      0x06 : UnChanged
//      0x07 : Reserved
// TYPE_LENGTH : size = 1byte : contains the length in bytes of the TYPE field. Current NDEF standard dictates TYPE to be 2 or 5 bytes long.
// PAYLOAD_LENGTH : size = 1 or 4 bytes (determined by StatusByte.SR field, if SR=1 then PAYLOAD_LENGTH is 1 byte, else 4 bytes) : contains the length in bytes of the NDEF message payload section.
// ID_LENGTH : size = 1 byte : determines the size in bytes of the ID field. Typically 1 or 0. If 0 then there is no ID field.
// TYPE : size =determined by TYPE_LENGTH : contains ASCII characters that determine the type of the message, used with the StatusByte.TNF section to determine the message type (ie a TNF of 0x01 for Well Known Type and a TYPE field of ‘T’ would tell us that the NDEF message payload is a Text record. A Type of “U” means URI, and a Type of “Sp” means SmartPoster).
// ID : size = determined by ID_LENGTH field : holds unique identifier for the message. Usually used with message chunking to identify sections of data, or for custom implementations.
// PAYLOAD : size = determined by PAYLOAD_LENGTH : contains the payload for the message. The payload is where the actual data transfer happens.
+ (nullable VYNFCNDEFMessageHeader *)parseMessageHeader:(unsigned char*)payloadBytes length:(NSUInteger)length {
    if (length == 0) {
        return nil;
    }

    NSUInteger index = 0;
    VYNFCNDEFMessageHeader *header = [VYNFCNDEFMessageHeader new];

    // Parse status byte.
    char statusByte = payloadBytes[index++];
    header.isMessageBegin = statusByte & 0x80;
    header.isMessageEnd = statusByte & 0x40;
    header.isChunkedUp = statusByte & 0x20;
    header.isShortRecord = statusByte & 0x10;
    header.isIdentifierPresent = statusByte & 0x08;
    header.typeNameFormatCode = (NFCTypeNameFormat)(statusByte & 0x07);

    // Parse type length.
    if (index + 1 > length) {
        return nil;
    }
    uint8_t typeLength = payloadBytes[index++];

    // Parse payload length.
    if ((header.isShortRecord && index + 1 > length) || (!header.isShortRecord && index + 4 > length)) {
        return nil;
    }
    if (header.isShortRecord) {
        header.payloadLength = (uint32_t)payloadBytes[index];
        index += 1;
    } else {
        header.payloadLength = *((uint32_t *)(payloadBytes + index));
        index += 4;
    }

    // Parse ID length if ID is present.
    uint8_t identifierLength = 0;
    if (header.isIdentifierPresent) {
        if (index + 1 > length) {
            return nil;
        }
        identifierLength = payloadBytes[index++];
    }

    // Parse type.
    if (index + typeLength > length) {
        return nil;
    }
    header.type = [[NSString alloc] initWithBytes:payloadBytes + index length:typeLength encoding:NSUTF8StringEncoding];
    if (!header.type) {
        return nil;
    }
    index += typeLength;

    // Parse ID if ID is present.
    if (identifierLength > 0) {
        if (index + 1 > length) {
            return nil;
        }
        header.identifer = payloadBytes[index]; // Note by vince: maybe it could be longer.
        index += identifierLength;
    }

    header.payloadOffset = index;
    return header;
}

# pragma mark - Parse Media Type

+ (nullable id)parseTextXVCardPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
    VYNFCNDEFTextXVCardPayload *payload = [VYNFCNDEFTextXVCardPayload new];
    NSString *text = [[NSString alloc] initWithBytes:payloadBytes length:length encoding:NSUTF8StringEncoding];
    if (!text) {
        return nil;
    }
    payload.text = text;
    return payload;
}

#define CREDENTIAL      "\x10\x0e"
#define SSID            "\x10\x45"
#define MAC_ADDRESS     "\x10\x20"
#define NETWORK_INDEX   "\x10\x26"
#define NETWORK_KEY     "\x10\x27"
#define AUTH_TYPE       "\x10\x03"
#define ENCRYPT_TYPE    "\x10\x0f"
#define VENDOR_EXT      "\x10\x49"

#define VENDOR_ID_WFA "\x00\x37\x2a"
#define WFA_VERSION2 "\x00"

#define AUTH_OPEN               "\x00\x01"
#define AUTH_WPA_PERSONAL       "\x00\x02"
#define AUTH_SHARED             "\x00\x04"
#define AUTH_WPA_ENTERPRISE     "\x00\x08"
#define AUTH_WPA2_ENTERPRISE    "\x00\x10"
#define AUTH_WPA2_PERSONAL      "\x00\x20"
#define AUTH_WPA_WPA2_PERSONAL  "\x00\x22"

#define ENCRYPT_NONE      "\x00\x01"
#define ENCRYPT_WEP       "\x00\x02"
#define ENCRYPT_TKIP      "\x00\x04"
#define ENCRYPT_AES       "\x00\x08"
#define ENCRYPT_AES_TKIP  "\x00\x0C"
// ----Attribute types and sizes defined for Wi-Fi Simple Configuration----
// Description                      ID              Length
// Credential                       0x100E          unlimited
// SSID                             0x1045          <= 32B
// MAC Address                      0x1020          6B
// Network Index                    0x1026          1B
// Network Key                      0x1027          <= 64B
// Authentication Type              0x1003          2B
// Encryption Type                  0x100F          2B
// Vendor Extension                 0x1049          <= 1024B
//
+ (nullable id)parseWifiSimpleConfigPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
    if (length < 2) {
        return nil;
    }
    VYNFCNDEFWifiSimpleConfigPayload *payload = [VYNFCNDEFWifiSimpleConfigPayload new];

    NSUInteger index = 0;
    while (index <= length - 2) {
        if (memcmp(payloadBytes + index, VENDOR_EXT, 2) == 0) {
            // Parse vendor extension
            index += 2;
            if (index + 2 > length) {
                return nil;
            }
            uint16_t ext_length = uint16FromBigEndian(payloadBytes + index);
            index += 2;
            payload.version2 = [VYNFCNDEFPayloadParser parseWifiSimpleConfigVersion2:payloadBytes + index length:ext_length];
            index += ext_length;

        } else if (memcmp(payloadBytes + index, CREDENTIAL, 2) == 0) {
            // Parse credential
            index += 2;
            uint16_t credential_length = uint16FromBigEndian(payloadBytes + index);
            index += 2;
            VYNFCNDEFWifiSimpleConfigCredential *credential =
            [VYNFCNDEFPayloadParser parseWifiSimpleConfigCredential:payloadBytes + index length:credential_length];;
            if (!credential) {
                return nil;
            }
            [payload.credentials addObject:credential];
            index += credential_length;

        } else {
            break;
        }
    }

    return payload;
}

+ (nullable VYNFCNDEFWifiSimpleConfigCredential *)parseWifiSimpleConfigCredential:(unsigned char*)payloadBytes length:(NSUInteger)length {
    if (length < 2) {
        return nil;
    }
    VYNFCNDEFWifiSimpleConfigCredential *credential = [VYNFCNDEFWifiSimpleConfigCredential new];

    NSUInteger index = 0;
    while (index <= length - 2) {
        if (memcmp(payloadBytes + index, SSID, 2) == 0) {
            // Parse SSID
            index += 2;
            uint16_t sublength = uint16FromBigEndian(payloadBytes + index);
            index += 2;
            NSString *text = [[NSString alloc] initWithBytes:payloadBytes + index length:sublength encoding:NSUTF8StringEncoding];
            if (!text) {
                return nil;
            }
            credential.ssid = text;
            index += sublength;

        } else if (memcmp(payloadBytes + index, MAC_ADDRESS, 2) == 0) {
            // Parse MAC address
            index += 2;
            index += 2; // Skip length
            credential.macAddress =
                [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                 payloadBytes[index], payloadBytes[index+1], payloadBytes[index+2],
                 payloadBytes[index+3], payloadBytes[index+4], payloadBytes[index+5]
                 ];
            index += 6;

        } else if (memcmp(payloadBytes + index, NETWORK_INDEX, 2) == 0) {
            // Parse network index (there could be more than one network).
            index += 2;
            uint8_t netIndex = (uint8_t)payloadBytes[index];
            credential.networkIndex = netIndex;
            index += 1;

        } else if (memcmp(payloadBytes + index, NETWORK_KEY, 2) == 0) {
            // Parse network key (password)
            index += 2;
            uint16_t sublength = uint16FromBigEndian(payloadBytes + index);
            index += 2;
            NSString *text = [[NSString alloc] initWithBytes:payloadBytes + index length:sublength encoding:NSUTF8StringEncoding];
            if (!text) {
                return nil;
            }
            credential.networkKey = text;
            index += sublength;

        } else if (memcmp(payloadBytes + index, AUTH_TYPE, 2) == 0) {
            // Parse authentication type
            index += 2;
            index += 2; // Skip length
            VYNFCNDEFWifiSimpleConfigAuthType type = VYNFCNDEFWifiSimpleConfigAuthTypeOpen;
            if (memcmp(payloadBytes + index, AUTH_OPEN, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeOpen;
            } else if (memcmp(payloadBytes + index, AUTH_WPA_PERSONAL, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeWpaPersonal;
            } else if (memcmp(payloadBytes + index, AUTH_SHARED, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeShared;
            } else if (memcmp(payloadBytes + index, AUTH_WPA_ENTERPRISE, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeWpaEnterprise;
            } else if (memcmp(payloadBytes + index, AUTH_WPA2_ENTERPRISE, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Enterprise;
            } else if (memcmp(payloadBytes + index, AUTH_WPA2_PERSONAL, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal;
            } else if (memcmp(payloadBytes + index, AUTH_WPA_WPA2_PERSONAL, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigAuthTypeWpaWpa2Personal;
            } else {
                // Unhandled auth type.
            }
            credential.authType = type;
            index += 2;

        } else if (memcmp(payloadBytes + index, ENCRYPT_TYPE, 2) == 0) {
            // Parse encryption type
            index += 2;
            index += 2; // Skip length
            VYNFCNDEFWifiSimpleConfigEncryptType type = VYNFCNDEFWifiSimpleConfigEncryptTypeNone;
            if (memcmp(payloadBytes + index, ENCRYPT_NONE, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigEncryptTypeNone;
            } else if (memcmp(payloadBytes + index, ENCRYPT_WEP, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigEncryptTypeWep;
            } else if (memcmp(payloadBytes + index, ENCRYPT_TKIP, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigEncryptTypeTkip;
            } else if (memcmp(payloadBytes + index, ENCRYPT_AES, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigEncryptTypeAes;
            } else if (memcmp(payloadBytes + index, ENCRYPT_AES_TKIP, 2) == 0) {
                type = VYNFCNDEFWifiSimpleConfigEncryptTypeAesTkip;
            } else {
                // Unhandled encryption type.
            }
            credential.encryptType = type;
            index += 2;

        } else { // Unknown attribute
            // In "Wi-Fi Simple Configuration Technical Specification v2.0.4", page 100 (Configuration Token
            // - Credential - Data Element Definitions), it says "Note: Unrecognized attributes in messages
            // shall beignored; they shall not cause the message to be rejected."
            // Currently we found unknown attribute: 0x0101
            index += 2;
        }
    }

    return credential;
}

// ---------------WFA Vendor Extension Subelements-------------------------
// Description                      ID              Length
// Version2                         0x00            1B
// AuthorizedMACs                   0x01            <=30B
// Network Key Shareable            0x02            Bool
// Request to Enroll                0x03            Bool
// Settings Delay Time              0x04            1B
// Registrar Configuration  Methods 0x05            2B
// Reserved for future use          0x06 to 0xFF

// Version2 value: 0x20 = version 2.0, 0x21 = version 2.1, etc. Shall be included in protocol version 2.0 and higher.
// If Version2 does not exist, assume version is "1.0h".
+ (nullable VYNFCNDEFWifiSimpleConfigVersion2 *)parseWifiSimpleConfigVersion2:(unsigned char*)payloadBytes length:(NSUInteger)length {
    NSUInteger index = 0;
    if (index + 3 > length) {
        return nil;
    }
    VYNFCNDEFWifiSimpleConfigVersion2 *version2 = [VYNFCNDEFWifiSimpleConfigVersion2 new];
    if (memcmp(payloadBytes + index, VENDOR_ID_WFA, 3) == 0) {
        // Parse vendor extension wfa
        index += 3;
        if (index + 1 > length) {
            return nil;
        }
        if (memcmp(payloadBytes + index, WFA_VERSION2, 1) == 0) {
            index += 1;
            // Parse Version2
            uint8_t ver2_length = payloadBytes[index];
            if (ver2_length != 1) {
                return nil;
            }
            index += 1;
            uint8_t ver = payloadBytes[index];
            if (ver == '\x20') {
                version2.version = @"2.0";
            } else if (ver == '\x21') {
                version2.version = @"2.1";
            } else {
                return nil;
            }
            index += 1;
        }
    }
    return version2;
}

@end

uint16_t uint16FromBigEndian(unsigned char*p) {
    return CFSwapInt16BigToHost(*((uint16_t *)p));
}
