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

@interface VYNFCNDEFWifiSimpleConfigCredential: NSObject
@property (nonatomic, copy) NSString * _Nonnull ssid;
@end

@interface VYNFCNDEFWifiSimpleConfigVersion2: NSObject
@property (nonatomic, copy) NSString * _Nonnull version;
@end

@interface VYNFCNDEFWifiSimpleConfigPayload : VYNFCNDEFMediaPayload
@property (nonatomic, strong) VYNFCNDEFWifiSimpleConfigCredential * _Nonnull credential;
@property (nonatomic, strong) VYNFCNDEFWifiSimpleConfigVersion2 * _Nullable version2;
@end
