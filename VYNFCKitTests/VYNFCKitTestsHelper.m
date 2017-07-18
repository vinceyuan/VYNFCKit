//
//  VYNFCKitTestsHelper.m
//  VYNFCKitTests
//
//  Created by Vince Yuan on 7/9/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "VYNFCKitTestsHelper.h"
#import <CoreNFC/CoreNFC.h>

@implementation VYNFCKitTestsHelper

+ (NFCNDEFPayload *)correctTextPayloadEnglish {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"T" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [@"\2enThis is text." dataUsingEncoding:NSUTF8StringEncoding];
    return payload;
}

+ (NFCNDEFPayload *)correctTextPayloadChinese {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"T" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [@"\2cn你好hello" dataUsingEncoding:NSUTF8StringEncoding];
    return payload;
}

+ (NFCNDEFPayload *)correctURIPayload {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"U" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [@"\4example.com" dataUsingEncoding:NSUTF8StringEncoding];
    return payload;
}

+ (NFCNDEFPayload *)correctTextXVCardPayload {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatMedia;
    payload.type = [@"text/x-vCard" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [@"BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD" dataUsingEncoding:NSUTF8StringEncoding];
    return payload;
}

+ (NFCNDEFPayload *)correctSmartPosterPayloadPhoneNumber {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"Sp" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x91\x01\x0b\x55\x05\x35\x35\x35\x31\x32\x33\x36\x36\x36\x36\x51\x01\x0d\x54\x02\x65\x6e\x56\x69\x6e\x63\x65\x20\x59\x75\x61\x6e" length:32];
    return payload;
}

+ (NFCNDEFPayload *)correctSmartPosterPayloadGeoLocation {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"Sp" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x91\x01\x18\x55\x00\x67\x65\x6f\x3a\x31\x2e\x33\x35\x31\x32\x31\x30\x2c\x31\x30\x33\x2e\x38\x36\x38\x38\x35\x36\x51\x01\x0c\x54\x02\x65\x6e\x53\x69\x6e\x67\x61\x70\x6f\x72\x65" length:44];
    return payload;
}

@end
