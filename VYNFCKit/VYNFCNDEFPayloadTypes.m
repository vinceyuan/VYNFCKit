//
//  VYNFCNDEFPayloadTypes.m
//  VYNFCKit
//
//  Created by Vince Yuan on 7/14/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "VYNFCNDEFPayloadTypes.h"

# pragma mark - Base classes

@implementation VYNFCNDEFPayload
@end

@implementation VYNFCNDEFWellKnownPayload
@end

@implementation VYNFCNDEFMediaPayload
@end

# pragma mark - Well Known Type

@implementation VYNFCNDEFTextPayload
@end

@implementation VYNFCNDEFURIPayload
@end

@implementation VYNFCNDEFSmartPosterPayload
@end

# pragma mark - Media Type

@implementation VYNFCNDEFTextXVCardPayload
@end

@implementation VYNFCNDEFWifiSimpleConfigCredential

+ (NSString *)authTypeString:(VYNFCNDEFWifiSimpleConfigAuthType)type {
    switch (type) {
        case VYNFCNDEFWifiSimpleConfigAuthTypeOpen: return @"Open";
        case VYNFCNDEFWifiSimpleConfigAuthTypeWpaPersonal: return @"WPA Personal";
        case VYNFCNDEFWifiSimpleConfigAuthTypeShared: return @"Shared";
        case VYNFCNDEFWifiSimpleConfigAuthTypeWpaEnterprise: return @"WPA Enterprise";
        case VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Enterprise: return @"WPA2 Enterprise";
        case VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal: return @"WPA2 Personal";
        case VYNFCNDEFWifiSimpleConfigAuthTypeWpaWpa2Personal: return @"WPA/WPA2 Personal";
        default: return @"Unknown";
    }
}

+ (NSString *)encryptTypeString:(VYNFCNDEFWifiSimpleConfigEncryptType)type {
    switch (type) {
        case VYNFCNDEFWifiSimpleConfigEncryptTypeNone: return @"None";
        case VYNFCNDEFWifiSimpleConfigEncryptTypeWep: return @"WEP";
        case VYNFCNDEFWifiSimpleConfigEncryptTypeTkip: return @"TKIP";
        case VYNFCNDEFWifiSimpleConfigEncryptTypeAes: return @"AES";
        case VYNFCNDEFWifiSimpleConfigEncryptTypeAesTkip: return @"AES/TKIP";
        default: return @"Unknown";
    }
}

@end

@implementation VYNFCNDEFWifiSimpleConfigVersion2
@end

@implementation VYNFCNDEFWifiSimpleConfigPayload

- (instancetype)init {
    if (self = [super init]) {
        _credentials = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
