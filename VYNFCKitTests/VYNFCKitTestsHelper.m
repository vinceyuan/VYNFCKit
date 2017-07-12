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
@end
