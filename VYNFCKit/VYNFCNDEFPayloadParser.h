//
//  VYNFCNDEFPayloadParser.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFCNDEFPayload;

typedef NS_ENUM(uint8_t, VYNFCNDEFPayloadType) {
    VYNFCNDEFPayloadTypeText        = 0x00,
    VYNFCNDEFPayloadTypeURI         = 0x01,
    VYNFCNDEFPayloadTypeTextXVCard  = 0x02,
};

@interface VYNFCNDEFPayload : NSObject

@property (nonatomic, assign) VYNFCNDEFPayloadType type;
@property (nonatomic, copy) NSString * _Nullable text;
@property (nonatomic, copy) NSString * _Nullable langCode; // Valid only when type is VYNFCNDEFPayloadTypeText

- (nonnull instancetype)initWithType:(VYNFCNDEFPayloadType)type;

@end

@interface VYNFCNDEFPayloadParser : NSObject

+ (nullable VYNFCNDEFPayload *)parse:(nullable NFCNDEFPayload *)payload;

@end
