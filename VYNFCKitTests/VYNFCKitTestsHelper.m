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

+ (NFCNDEFPayload *)correctSmartPosterPayloadPhoneNumberLong {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"Sp" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x91\x01\x0b\x55\x05\x35\x35\x35\x31\x32\x33\x36\x36\x36\x36\x51\x01\x6a\x54\x02\x65\x6e\x54\x68\x69\x73\x20\x70\x68\x6f\x6e\x65\x20\x6e\x75\x6d\x62\x65\x72\x20\x6f\x77\x6e\x65\x72\x27\x73\x20\x6e\x61\x6d\x65\x20\x69\x73\x20\x76\x65\x72\x79\x20\x6c\x6f\x6e\x67\x20\x61\x6e\x64\x20\x63\x6f\x6e\x74\x61\x69\x6e\x73\x20\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x20\x69\x6e\x20\x73\x69\x6d\x70\x6c\x69\x66\x69\x65\x64\x20\x43\x68\x69\x6e\x65\x73\x65\x20\xe4\xbd\xa0\xe5\xa5\xbd\xe4\xb8\x96\xe7\x95\x8c" length:125];
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

+ (NFCNDEFPayload *)correctSmartPosterPayloadSms {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"Sp" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x91\x01\x64\x55\x00\x73\x6d\x73\x3a\x35\x35\x35\x31\x32\x33\x36\x36\x36\x36\x3f\x62\x6f\x64\x79\x3d\x54\x68\x69\x73\x20\x69\x73\x20\x61\x20\x6c\x6f\x6e\x67\x20\x74\x65\x78\x74\x20\x6d\x65\x73\x73\x61\x67\x65\x20\x77\x69\x74\x68\x20\x73\x6f\x6d\x65\x20\x73\x69\x6d\x70\x6c\x69\x66\x65\x64\x20\x43\x68\x69\x6e\x65\x73\x65\x20\x63\x68\x61\x72\x61\x63\x74\x65\x72\x73\x20\xe4\xbd\xa0\xe5\xa5\xbd\xe4\xb8\x96\xe7\x95\x8c\x51\x01\x18\x54\x02\x65\x6e\x44\x65\x73\x63\x72\x69\x70\x74\x69\x6f\x6e\x3a\x20\x73\x65\x6e\x64\x20\x73\x6d\x73" length:132];
    return payload;
}

+ (NFCNDEFPayload *)correctWifiSimpleConfigPayloadWith1Credential {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatMedia;
    payload.type = [@"application/vnd.wfa.wsc" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x10\x0e\x00\x30\x10\x45\x00\x0a\x4d\x79\x57\x69\x66\x69\x53\x53\x49\x44\x10\x20\x00\x06\xff\xff\xff\xff\xff\xff\x10\x27\x00\x08\x70\x40\x73\x73\x57\x30\x72\x64\x10\x03\x00\x02\x00\x20\x10\x0f\x00\x02\x00\x08\x10\x49\x00\x06\x00\x37\x2a\x00\x01\x20" length:62];
    return payload;
}

+ (NFCNDEFPayload *)correctWifiSimpleConfigPayloadWith2Credetnials {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatMedia;
    payload.type = [@"application/vnd.wfa.wsc" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [NSData dataWithBytes:"\x10\x0e\x00\x3e\x10\x26\x00\x01\x01\x10\x45\x00\x0b\x57\x4c\x41\x4e\x2d\x58\x36\x36\x36\x36\x36\x10\x03\x00\x02\x00\x20\x10\x0f\x00\x02\x00\x08\x10\x27\x00\x10\x31\x33\x35\x38\x34\x35\x35\x32\x32\x39\x30\x34\x33\x33\x33\x33\x10\x20\x00\x06\xc4\xf0\x81\x83\x0a\x14\x10\x0e\x00\x3e\x10\x26\x00\x01\x01\x10\x45\x00\x0b\x57\x4c\x41\x4e\x2d\x58\x36\x36\x36\x36\x36\x10\x03\x00\x02\x00\x20\x10\x0f\x00\x02\x00\x08\x10\x27\x00\x10\x31\x33\x35\x38\x34\x35\x35\x32\x32\x39\x30\x34\x33\x33\x33\x33\x10\x20\x00\x06\xc4\xf0\x81\x83\x0a\x17" length:132];
    return payload;
}
@end
