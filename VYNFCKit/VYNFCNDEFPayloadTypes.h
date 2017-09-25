//
//  VYNFCNDEFPayloadTypes.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/14/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

# pragma mark - Base classes

@interface VYNFCNDEFPayload : NSObject
@end

@interface VYNFCNDEFWellKnownPayload : VYNFCNDEFPayload
@end

@interface VYNFCNDEFMediaPayload : VYNFCNDEFPayload
@end

# pragma mark - Well Known Type

@interface VYNFCNDEFTextPayload : VYNFCNDEFWellKnownPayload
@property (nonatomic, assign) BOOL isUTF16;
@property (nonatomic, copy) NSString * _Nonnull langCode;
@property (nonatomic, copy) NSString * _Nonnull text;
@end

@interface VYNFCNDEFURIPayload : VYNFCNDEFWellKnownPayload
@property (nonatomic, copy) NSString * _Nonnull URIString;
@end

@interface VYNFCNDEFSmartPosterPayload : VYNFCNDEFWellKnownPayload
@property (nonatomic, strong) VYNFCNDEFURIPayload * _Nonnull payloadURI;
@property (nonatomic, strong) NSArray * _Nonnull payloadTexts;
@end

# pragma mark - Media Type

@interface VYNFCNDEFTextXVCardPayload : VYNFCNDEFMediaPayload
@property (nonatomic, copy) NSString * _Nonnull text;
@end

typedef NS_ENUM(uint8_t, VYNFCNDEFWifiSimpleConfigAuthType) {
    VYNFCNDEFWifiSimpleConfigAuthTypeOpen               = 0x00,
    VYNFCNDEFWifiSimpleConfigAuthTypeWpaPersonal        = 0x01,
    VYNFCNDEFWifiSimpleConfigAuthTypeShared             = 0x02,
    VYNFCNDEFWifiSimpleConfigAuthTypeWpaEnterprise      = 0x03,
    VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Enterprise     = 0x04,
    VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal       = 0x05,
    VYNFCNDEFWifiSimpleConfigAuthTypeWpaWpa2Personal    = 0x06
};

typedef NS_ENUM(uint8_t, VYNFCNDEFWifiSimpleConfigEncryptType) {
    VYNFCNDEFWifiSimpleConfigEncryptTypeNone    = 0x00,
    VYNFCNDEFWifiSimpleConfigEncryptTypeWep     = 0x01,
    VYNFCNDEFWifiSimpleConfigEncryptTypeTkip    = 0x02,
    VYNFCNDEFWifiSimpleConfigEncryptTypeAes     = 0x03,
    VYNFCNDEFWifiSimpleConfigEncryptTypeAesTkip = 0x04,
};

@interface VYNFCNDEFWifiSimpleConfigCredential: NSObject
@property (nonatomic, copy) NSString * _Nonnull ssid;
@property (nonatomic, copy) NSString * _Nonnull macAddress; // "ff:ff:ff:ff:ff:ff" means unlimited
@property (nonatomic, assign) uint8_t networkIndex;
@property (nonatomic, copy) NSString * _Nonnull networkKey;
@property (nonatomic, assign) VYNFCNDEFWifiSimpleConfigAuthType authType;
@property (nonatomic, assign) VYNFCNDEFWifiSimpleConfigEncryptType encryptType;

+ (NSString * _Nonnull)authTypeString:(VYNFCNDEFWifiSimpleConfigAuthType)type;
+ (NSString * _Nonnull)encryptTypeString:(VYNFCNDEFWifiSimpleConfigEncryptType)type;
@end

@interface VYNFCNDEFWifiSimpleConfigVersion2: NSObject
@property (nonatomic, copy) NSString * _Nonnull version;
@end

@interface VYNFCNDEFWifiSimpleConfigPayload : VYNFCNDEFMediaPayload
@property (nonatomic, strong) NSMutableArray<VYNFCNDEFWifiSimpleConfigCredential *>* _Nonnull credentials; // There could be more than one credential (e.g. 1 for 2.5GHz and 1 for 5GHz).
@property (nonatomic, strong) VYNFCNDEFWifiSimpleConfigVersion2 * _Nullable version2;
@end
