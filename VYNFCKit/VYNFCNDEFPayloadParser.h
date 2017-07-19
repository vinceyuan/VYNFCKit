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

@class NFCNDEFPayload;

@interface VYNFCNDEFPayloadParser : NSObject

+ (nullable id)parse:(nullable NFCNDEFPayload *)payload;

@end
