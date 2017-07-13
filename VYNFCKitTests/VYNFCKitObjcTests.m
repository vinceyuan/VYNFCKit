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
    NFCNDEFPayload *payloadEn = [VYNFCKitTestsHelper correctTextPayloadEnglish];
    id parsedPayloadEnUntyped = [VYNFCNDEFPayloadParser parse:payloadEn];
    XCTAssertNotNil(parsedPayloadEnUntyped);
    XCTAssert([parsedPayloadEnUntyped isKindOfClass:[VYNFCNDEFPayloadText class]]);
    VYNFCNDEFPayloadText *parsedPayloadEn = parsedPayloadEnUntyped;
    XCTAssertEqual(parsedPayloadEn.isUTF16, NO);
    XCTAssert([parsedPayloadEn.langCode isEqualToString:@"en"]);
    XCTAssert([parsedPayloadEn.text isEqualToString:@"This is text."]);

    NFCNDEFPayload *payloadCn = [VYNFCKitTestsHelper correctTextPayloadChinese];
    id parsedPayloadCnUntyped = [VYNFCNDEFPayloadParser parse:payloadCn];
    XCTAssertNotNil(parsedPayloadCnUntyped);
    XCTAssert([parsedPayloadCnUntyped isKindOfClass:[VYNFCNDEFPayloadText class]]);
    VYNFCNDEFPayloadText *parsedPayloadCn = parsedPayloadCnUntyped;
    XCTAssertEqual(parsedPayloadCn.isUTF16, NO);
    XCTAssert([parsedPayloadCn.langCode isEqualToString:@"cn"]);
    XCTAssert([parsedPayloadCn.text isEqualToString:@"你好hello"]);
}

- (void)testURIPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctURIPayload];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssert([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFPayloadURI class]]);
    VYNFCNDEFPayloadURI *parsedPayload = parsedPayloadUntyped;
    XCTAssert([parsedPayload.URIString isEqualToString:@"https://example.com"]);
}

- (void)testTextXVCardPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextXVCardPayload];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssert([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFPayloadTextXVCard class]]);
    VYNFCNDEFPayloadTextXVCard *parsedPayload = parsedPayloadUntyped;
    XCTAssert([parsedPayload.text isEqualToString:@"BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
