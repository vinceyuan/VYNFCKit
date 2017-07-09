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

- (nullable VYNFCNDEFPayload *)parse:(nullable NFCNDEFPayload *)payload; {
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
        return [self parseTextPayload:payloadString];
    } else if ([typeString isEqualToString:@"U"]) {
        return [self parseURIPayload:payloadString];
    } else if ([typeString isEqualToString:@"text/x-vCard"]) {
        return [self parseTextXVCardPayload:payloadString];
    }
    return nil;
}

- (nullable VYNFCNDEFPayload *)parseTextXVCardPayload:(NSString *)payloadString {
    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeTextXVCard];
    payload.text = payloadString;
    return payload;
}

- (nullable VYNFCNDEFPayload *)parseTextPayload:(NSString *)payloadString {
    NSUInteger length = [payloadString length];
    if (length < 2) {
        return nil;
    }

    NSString *langCode = [payloadString substringToIndex:2];
    NSString *text = [payloadString substringFromIndex:2];
    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeText];
    payload.text = text;
    return payload;
}

- (nullable VYNFCNDEFPayload *)parseURIPayload:(NSString *)payloadString {
    NSUInteger length = [payloadString length];
    if (length < 1) {
        return nil;
    }
    NSString *codeString = [payloadString substringToIndex:1];
    const char *codeCString = [codeString cStringUsingEncoding:NSASCIIStringEncoding];
    if (!codeCString) {
        return nil;
    }
    const uint8_t code = (const uint8_t)codeCString[0];

    VYNFCNDEFPayload *payload = [[VYNFCNDEFPayload alloc] initWithType:VYNFCNDEFPayloadTypeURI];
    NSString *text;
    switch (code) {
        case 0x00: // N/A. No prepending is done
            text = payloadString; break;
        case 0x01: // http://www.
            text = [@"http://www." stringByAppendingString:payloadString]; break;
        case 0x02: // https://www.
            text = [@"https://www." stringByAppendingString:payloadString]; break;
        case 0x03: // http://
            text = [@"http://" stringByAppendingString:payloadString]; break;
        case 0x04: // https://
            text = [@"https://" stringByAppendingString:payloadString]; break;
        case 0x05: // tel:
            text = [@"tel:" stringByAppendingString:payloadString]; break;
        case 0x06: // mailto:
            text = [@"mailto:" stringByAppendingString:payloadString]; break;
        case 0x07: // ftp://anonymous:anonymous@
            text = [@"ftp://anonymous:anonymous@" stringByAppendingString:payloadString]; break;
        case 0x08: // ftp://ftp.
            text = [@"ftp://ftp." stringByAppendingString:payloadString]; break;
        case 0x09: // ftps://
            text = [@"ftps://" stringByAppendingString:payloadString]; break;
        case 0x0A: // sftp://
            text = [@"sftp://" stringByAppendingString:payloadString]; break;
        case 0x0B: // smb://
            text = [@"smb://" stringByAppendingString:payloadString]; break;
        case 0x0C: // nfs://
            text = [@"nfs://" stringByAppendingString:payloadString]; break;
        case 0x0D: // ftp://
            text = [@"ftp://" stringByAppendingString:payloadString]; break;
        case 0x0E: // dav://
            text = [@"dav://" stringByAppendingString:payloadString]; break;
        case 0x0F: // news:
            text = [@"news:" stringByAppendingString:payloadString]; break;
        case 0x10: // telnet://
            text = [@"telnet://" stringByAppendingString:payloadString]; break;
        case 0x11: // imap:
            text = [@"imap:" stringByAppendingString:payloadString]; break;
        case 0x12: // rtsp://
            text = [@"rtsp://" stringByAppendingString:payloadString]; break;
        case 0x13: // urn:
            text = [@"urn:" stringByAppendingString:payloadString]; break;
        case 0x14: // pop:
            text = [@"pop:" stringByAppendingString:payloadString]; break;
        case 0x15: // sip:
            text = [@"sip:" stringByAppendingString:payloadString]; break;
        case 0x16: // sips:
            text = [@"sips:" stringByAppendingString:payloadString]; break;
        case 0x17: // tftp:
            text = [@"tftp:" stringByAppendingString:payloadString]; break;
        case 0x18: // btspp://
            text = [@"btspp://" stringByAppendingString:payloadString]; break;
        case 0x19: // btl2cap://
            text = [@"btl2cap://" stringByAppendingString:payloadString]; break;
        case 0x1A: // btgoep://
            text = [@"btgoep://" stringByAppendingString:payloadString]; break;
        case 0x1B: // tcpobex://
            text = [@"tcpobex://" stringByAppendingString:payloadString]; break;
        case 0x1C: // irdaobex://
            text = [@"irdaobex://" stringByAppendingString:payloadString]; break;
        case 0x1D: // file://
            text = [@"file://" stringByAppendingString:payloadString]; break;
        case 0x1E: // urn:epc:id:
            text = [@"urn:epc:id:" stringByAppendingString:payloadString]; break;
        case 0x1F: // urn:epc:tag:
            text = [@"urn:epc:tag:" stringByAppendingString:payloadString]; break;
        case 0x20: // urn:epc:pat:
            text = [@"urn:epc:pat:" stringByAppendingString:payloadString]; break;
        case 0x21: // urn:epc:raw:
            text = [@"urn:epc:raw:" stringByAppendingString:payloadString]; break;
        case 0x22: // urn:epc:
            text = [@"urn:epc:" stringByAppendingString:payloadString]; break;
        case 0x23: // urn:nfc:
            text = [@"urn:nfc:" stringByAppendingString:payloadString]; break;
        default: // 0x24-0xFF RFU Reserved for Future Use, Not Valid Inputs
            return nil;
    }
    payload.text = text;
    return payload;
}

@end
