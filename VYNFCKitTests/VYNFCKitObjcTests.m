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
    VYNFCNDEFPayloadParser *parser = [[VYNFCNDEFPayloadParser alloc] init];

    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextPayload];
    VYNFCNDEFPayload *parsedPayload = [parser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeText);
    XCTAssert([parsedPayload.text isEqualToString:@"This is text."]);
}

- (void)testURIPayload {
    VYNFCNDEFPayloadParser *parser = [[VYNFCNDEFPayloadParser alloc] init];

    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctURIPayload];
    VYNFCNDEFPayload *parsedPayload = [parser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeURI);
    XCTAssert([parsedPayload.text isEqualToString:@"https://example.com"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
