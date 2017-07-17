//
//  VYNFCNDEFMessageHeader.h
//  VYNFCKit
//
//  Created by Vince Yuan on 7/18/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreNFC/CoreNFC.h>

@interface VYNFCNDEFMessageHeader : NSObject

@property (nonatomic, assign) BOOL isMessageBegin;
@property (nonatomic, assign) BOOL isMessageEnd;
@property (nonatomic, assign) BOOL isChunkedUp;
@property (nonatomic, assign) BOOL isShortRecord;
@property (nonatomic, assign) BOOL isIdentifierPresent;
@property (nonatomic, assign) NFCTypeNameFormat typeNameFormatCode;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) uint8_t identifer;
@property (nonatomic, assign) uint32_t payloadLength;

@property (nonatomic, assign) NSUInteger payloadOffset; // Length of parsed bytes before payload

@end
