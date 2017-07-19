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
+ (NFCNDEFPayload *)correctURIPayload;
+ (NFCNDEFPayload *)correctTextXVCardPayload;

+ (NFCNDEFPayload *)correctSmartPosterPayloadPhoneNumber;
+ (NFCNDEFPayload *)correctSmartPosterPayloadPhoneNumberLong;
+ (NFCNDEFPayload *)correctSmartPosterPayloadGeoLocation;
+ (NFCNDEFPayload *)correctSmartPosterPayloadSms;

@end
