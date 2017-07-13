//
//  VYNFCNDEFPayloadTypes.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/14/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VYNFCNDEFPayloadText : NSObject
@property (nonatomic, assign) BOOL isUTF16;
@property (nonatomic, copy) NSString * _Nonnull langCode;
@property (nonatomic, copy) NSString * _Nonnull text;
@end

@interface VYNFCNDEFPayloadURI : NSObject
@property (nonatomic, copy) NSString * _Nonnull URIString;
@end

@interface VYNFCNDEFPayloadTextXVCard : NSObject
@property (nonatomic, copy) NSString * _Nonnull text;
@end
