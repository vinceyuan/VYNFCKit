//
//  VYNFCNDEFPayloadParser.m
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "VYNFCNDEFPayloadParser.h"
#import <CoreNFC/CoreNFC.h>

@implementation VYNFCNDEFPayload

- (nonnull instancetype)initWithType:(VYNFCNDEFPayloadType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
@end

@implementation VYNFCNDEFPayloadParser

+ (nullable VYNFCNDEFPayload *)parse:(nullable NFCNDEFPayload *)payload; {
    // Currently we only support well known format.
    if (!payload
        || payload.typeNameFormat != NFCTypeNameFormatNFCWellKnown
        ) {
        return nil;
    }

    NSString *typeString = [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding];
    NSString *identifierString = [[NSString alloc] initWithData:payload.identifier encoding:NSUTF8StringEncoding];
    NSString *payloadString = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
    if (!typeString || !identifierString || !payloadString) {
        return nil;
    }

    if ([typeString isEqualToString:@"T"]) {
        return [VYNFCNDEFPayloadParser parseTextPayload:payloadString];
    } else if ([typeString isEqualToString:@"U"]) {
        return [VYNFCNDEFPayloadParser parseURIPayload:payloadString];
    } else if ([typeString isEqualToString:@"text/x-vCard"]) {
        return [VYNFCNDEFPayloadParser parseTextXVCardPayload:payloadString];
    }
    return nil;
}

+ (nullable VYNFCNDEFPayload *)parseTextXVCardPayload:(NSString *)payloadString {
    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeTextXVCard];
    payload.text = payloadString;
    return payload;
}

// |------------------------------|
// |     Length of Lang Code      |  1 byte Text Record StatusByte
// |------------------------------|
// |          Lang Code           |  2 or 5 bytes, multi-byte language code
// |------------------------------|
// |             Text             |  Multiple Bytes encoded in UTF-8 or UTF-16
// |------------------------------|
// Example: "\2enThis is text."
+ (nullable VYNFCNDEFPayload *)parseTextPayload:(NSString *)payloadString {
    NSUInteger length = [payloadString length];
    if (length < 1) {
        return nil;
    }

    // Get length of lang code.
    NSString *codeLengthString = [payloadString substringToIndex:1];
    const char *codeLengthCString = [codeLengthString cStringUsingEncoding:NSASCIIStringEncoding];
    if (!codeLengthCString) {
        return nil;
    }
    const uint8_t codeLength = (const uint8_t)codeLengthCString[0];
    if (length < 1 + codeLength) {
        return nil;
    }

    // Get lang code and text.
    NSString *langCode = [payloadString substringWithRange:NSMakeRange(1, codeLength)];
    NSString *text = [payloadString substringFromIndex:1 + codeLength];
    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeText];
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
+ (nullable VYNFCNDEFPayload *)parseURIPayload:(NSString *)payloadString {
    NSUInteger length = [payloadString length];
    if (length < 1) {
        return nil;
    }

    // Get ID code and original text.
    NSString *codeString = [payloadString substringToIndex:1];
    const char *codeCString = [codeString cStringUsingEncoding:NSASCIIStringEncoding];
    if (!codeCString) {
        return nil;
    }
    const uint8_t code = (const uint8_t)codeCString[0];
    NSString *originalText = [payloadString substringFromIndex:1];

    // Add prefix according to ID code.
    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeURI];
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
    payload.text = text;
    return payload;
}

@end
