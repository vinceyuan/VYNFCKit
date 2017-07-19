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

@interface VYNFCNDEFTextPayload : NSObject
@property (nonatomic, assign) BOOL isUTF16;
@property (nonatomic, copy) NSString * _Nonnull langCode;
@property (nonatomic, copy) NSString * _Nonnull text;
@end

@interface VYNFCNDEFURIPayload : NSObject
@property (nonatomic, copy) NSString * _Nonnull URIString;
@end

@interface VYNFCNDEFTextXVCardPayload : NSObject
@property (nonatomic, copy) NSString * _Nonnull text;
@end

@interface VYNFCNDEFSmartPosterPayload : NSObject
@property (nonatomic, strong) VYNFCNDEFURIPayload * _Nonnull payloadURI;
@property (nonatomic, strong) NSArray * _Nonnull payloadTexts;
@end
