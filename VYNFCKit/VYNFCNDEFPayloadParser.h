//
//  VYNFCNDEFPayloadParser.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFCNDEFPayload;

@interface VYNFCNDEFPayloadParser : NSObject

+ (nullable id)parse:(nullable NFCNDEFPayload *)payload;

@end
