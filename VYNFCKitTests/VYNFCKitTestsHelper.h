//
//  VYNFCKitTestsHelper.h
//  VYNFCKitTests
//
//  Created by Vince Yuan on 7/9/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFCNDEFPayload;

@interface VYNFCKitTestsHelper : NSObject

+ (NFCNDEFPayload *)correctTextPayloadEnglish;
+ (NFCNDEFPayload *)correctTextPayloadChinese;
+ (NFCNDEFPayload *)wrongTextPayload;
+ (NFCNDEFPayload *)correctURIPayload;
+ (NFCNDEFPayload *)wrongURIPayload;
+ (NFCNDEFPayload *)correctTextXVCardPayload;
+ (NFCNDEFPayload *)wrongTextXVCardPayload;

+ (NFCNDEFPayload *)correctSmartPosterPayload;

@end
