//
//  VYNFCKitObjcTests.m
//  VYNFCKitObjcTests
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <VYNFCKit/VYNFCKit.h>
#import <CoreNFC/CoreNFC.h>
#import "VYNFCKitTestsHelper.h"

@interface VYNFCKitObjcTests : XCTestCase

@end

@implementation VYNFCKitObjcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTextPayload {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    VYNFCNDEFPayloadParser *parser = [[VYNFCNDEFPayloadParser alloc] init];

    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextPayload];
    VYNFCNDEFPayload *parsedPayload = [parser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssert([parsedPayload.text isEqualToString:@"This is text."]);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeText);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
