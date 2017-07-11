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

+ (NFCNDEFPayload *)correctTextPayload {
    NFCNDEFPayload *payload = [NFCNDEFPayload new];
    payload.typeNameFormat = NFCTypeNameFormatNFCWellKnown;
    payload.type = [@"T" dataUsingEncoding:NSUTF8StringEncoding];
    payload.identifier = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    payload.payload = [@"\2enThis is text." dataUsingEncoding:NSUTF8StringEncoding];
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

@end
