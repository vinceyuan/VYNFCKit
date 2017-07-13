//
//  VYNFCNDEFPayloadParser.m
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "VYNFCNDEFPayloadParser.h"
#import <CoreNFC/CoreNFC.h>
#import "VYNFCNDEFPayloadTypes.h"

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
        }
    } else if (payload.typeNameFormat == NFCTypeNameFormatMedia) {
        if ([typeString isEqualToString:@"text/x-vCard"]) {
            return [VYNFCNDEFPayloadParser parseTextXVCardPayload:payloadBytes length:payloadBytesLength];
        }
    }
    return nil;
}

+ (nullable id)parseTextXVCardPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
    VYNFCNDEFPayloadTextXVCard *payload = [VYNFCNDEFPayloadTextXVCard new];
    NSString *text = [[NSString alloc] initWithBytes:payloadBytes length:length encoding:NSUTF8StringEncoding];
    if (!text) {
        return nil;
    }
    payload.text = text;
    return payload;
}

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
+ (nullable id)parseTextPayload:(unsigned char*)payloadBytes length:(NSUInteger)length {
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
    VYNFCNDEFPayloadText *payload = [VYNFCNDEFPayloadText new];
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
    VYNFCNDEFPayloadURI *payload = [VYNFCNDEFPayloadURI new];
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

@end
