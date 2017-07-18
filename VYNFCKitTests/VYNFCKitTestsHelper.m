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

+ (NFCNDEFPayload *)correctSmartPosterPayload {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"Sp" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x91\x01\x0b\x55\x05\x35\x35\x35\x31\x32\x33\x36\x36\x36\x36\x51\x01\x0d\x54\x02\x65\x6e\x56\x69\x6e\x63\x65\x20\x59\x75\x61\x6e" length:32];
    return payload;
}
@end
