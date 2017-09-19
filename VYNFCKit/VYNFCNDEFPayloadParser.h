//
//  VYNFCNDEFPayloadParser.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

@class NFCNDEFPayload, VYNFCNDEFMessageHeader;

API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(watchos, macos, tvos)
@interface VYNFCNDEFPayloadParser : NSObject

+ (nullable id)parse:(nullable NFCNDEFPayload *)payload;
+ (nullable VYNFCNDEFMessageHeader *)parseMessageHeader:(nullable unsigned char*)payloadBytes length:(NSUInteger)length;

@end
