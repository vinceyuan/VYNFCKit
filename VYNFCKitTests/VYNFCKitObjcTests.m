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
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextPayload];
    VYNFCNDEFPayload *parsedPayload = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeText);
    XCTAssert([parsedPayload.text isEqualToString:@"This is text."]);
}

- (void)testURIPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctURIPayload];
    VYNFCNDEFPayload *parsedPayload = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeURI);
    XCTAssert([parsedPayload.text isEqualToString:@"https://example.com"]);
}

- (void)testTextXVCardPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextXVCardPayload];
    VYNFCNDEFPayload *parsedPayload = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayload);
    XCTAssertEqual(parsedPayload.type, VYNFCNDEFPayloadTypeTextXVCard);
    XCTAssert([parsedPayload.text isEqualToString:@"BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
