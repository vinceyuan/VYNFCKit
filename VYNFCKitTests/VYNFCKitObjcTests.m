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
    XCTAssertTrue([parsedPayloadEnUntyped isKindOfClass:[VYNFCNDEFTextPayload class]]);
    VYNFCNDEFTextPayload *parsedPayloadEn = parsedPayloadEnUntyped;
    XCTAssertEqual(parsedPayloadEn.isUTF16, NO);
    XCTAssertTrue([parsedPayloadEn.langCode isEqualToString:@"en"]);
    XCTAssertTrue([parsedPayloadEn.text isEqualToString:@"This is text."]);

    NFCNDEFPayload *payloadCn = [VYNFCKitTestsHelper correctTextPayloadChinese];
    id parsedPayloadCnUntyped = [VYNFCNDEFPayloadParser parse:payloadCn];
    XCTAssertNotNil(parsedPayloadCnUntyped);
    XCTAssertTrue([parsedPayloadCnUntyped isKindOfClass:[VYNFCNDEFTextPayload class]]);
    VYNFCNDEFTextPayload *parsedPayloadCn = parsedPayloadCnUntyped;
    XCTAssertEqual(parsedPayloadCn.isUTF16, NO);
    XCTAssertTrue([parsedPayloadCn.langCode isEqualToString:@"cn"]);
    XCTAssertTrue([parsedPayloadCn.text isEqualToString:@"你好hello"]);
}

- (void)testURIPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctURIPayload];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFURIPayload class]]);
    VYNFCNDEFURIPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertTrue([parsedPayload.URIString isEqualToString:@"https://example.com"]);
}

- (void)testTextXVCardPayload {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctTextXVCardPayload];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFTextXVCardPayload class]]);
    VYNFCNDEFTextXVCardPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertTrue([parsedPayload.text isEqualToString:@"BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD"]);
}

- (void)testTextSmartPosterPayloadPhoneNumber {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctSmartPosterPayloadPhoneNumber];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]);
    VYNFCNDEFSmartPosterPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.payloadURI);
    XCTAssertTrue([parsedPayload.payloadURI.URIString isEqualToString:@"tel:5551236666"]);
    XCTAssertNotNil(parsedPayload.payloadTexts);
    XCTAssertEqual([parsedPayload.payloadTexts count], 1);
    VYNFCNDEFTextPayload *textPayload = [parsedPayload.payloadTexts firstObject];
    XCTAssertEqual(textPayload.isUTF16, NO);
    XCTAssertTrue([textPayload.langCode isEqualToString:@"en"]);
    XCTAssertTrue([textPayload.text isEqualToString:@"Vince Yuan"]);
}

- (void)testTextSmartPosterPayloadPhoneNumberLong {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctSmartPosterPayloadPhoneNumberLong];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]);
    VYNFCNDEFSmartPosterPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.payloadURI);
    XCTAssertTrue([parsedPayload.payloadURI.URIString isEqualToString:@"tel:5551236666"]);
    XCTAssertNotNil(parsedPayload.payloadTexts);
    XCTAssertEqual([parsedPayload.payloadTexts count], 1);
    VYNFCNDEFTextPayload *textPayload = [parsedPayload.payloadTexts firstObject];
    XCTAssertEqual(textPayload.isUTF16, NO);
    XCTAssertTrue([textPayload.langCode isEqualToString:@"en"]);
    XCTAssertTrue([textPayload.text isEqualToString:@"This phone number owner's name is very long and contains Hello World in simplified Chinese 你好世界"]);
}

- (void)testTextSmartPosterPayloadGeoLocation {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctSmartPosterPayloadGeoLocation];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]);
    VYNFCNDEFSmartPosterPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.payloadURI);
    XCTAssertTrue([parsedPayload.payloadURI.URIString isEqualToString:@"geo:1.351210,103.868856"]);
    XCTAssertNotNil(parsedPayload.payloadTexts);
    XCTAssertEqual([parsedPayload.payloadTexts count], 1);
    VYNFCNDEFTextPayload *textPayload = [parsedPayload.payloadTexts firstObject];
    XCTAssertEqual(textPayload.isUTF16, NO);
    XCTAssertTrue([textPayload.langCode isEqualToString:@"en"]);
    XCTAssertTrue([textPayload.text isEqualToString:@"Singapore"]);
}

- (void)testTextSmartPosterPayloadSms {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctSmartPosterPayloadSms];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]);
    VYNFCNDEFSmartPosterPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.payloadURI);
    XCTAssertTrue([parsedPayload.payloadURI.URIString isEqualToString:@"sms:5551236666?body=This is a long text message with some simplifed Chinese characters 你好世界"]);
    XCTAssertNotNil(parsedPayload.payloadTexts);
    XCTAssertEqual([parsedPayload.payloadTexts count], 1);
    VYNFCNDEFTextPayload *textPayload = [parsedPayload.payloadTexts firstObject];
    XCTAssertEqual(textPayload.isUTF16, NO);
    XCTAssertTrue([textPayload.langCode isEqualToString:@"en"]);
    XCTAssertTrue([textPayload.text isEqualToString:@"Description: send sms"]);
}

- (void)testWifiSimpleConfigPayloadWith1Credential {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctWifiSimpleConfigPayloadWith1Credential];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFWifiSimpleConfigPayload class]]);
    VYNFCNDEFWifiSimpleConfigPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.credentials);
    XCTAssertEqual([parsedPayload.credentials count], 1);
    VYNFCNDEFWifiSimpleConfigCredential *credential = parsedPayload.credentials.firstObject;
    XCTAssertTrue([credential.ssid isEqualToString:@"MyWifiSSID"]);
    XCTAssertTrue([credential.macAddress isEqualToString:@"ff:ff:ff:ff:ff:ff"]);
    XCTAssertEqual(credential.networkIndex, 0);
    XCTAssertTrue([credential.networkKey isEqualToString:@"p@ssW0rd"]);
    XCTAssertEqual(credential.authType, VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal);
    XCTAssertEqual(credential.encryptType, VYNFCNDEFWifiSimpleConfigEncryptTypeAes);
    XCTAssertNotNil(parsedPayload.version2);
    XCTAssertTrue([parsedPayload.version2.version isEqualToString:@"2.0"]);
}

- (void)testWifiSimpleConfigPayloadWith2Credentials {
    NFCNDEFPayload *payload = [VYNFCKitTestsHelper correctWifiSimpleConfigPayloadWith2Credetnials];
    id parsedPayloadUntyped = [VYNFCNDEFPayloadParser parse:payload];
    XCTAssertNotNil(parsedPayloadUntyped);
    XCTAssertTrue([parsedPayloadUntyped isKindOfClass:[VYNFCNDEFWifiSimpleConfigPayload class]]);
    VYNFCNDEFWifiSimpleConfigPayload *parsedPayload = parsedPayloadUntyped;
    XCTAssertNotNil(parsedPayload.credentials);
    XCTAssertEqual([parsedPayload.credentials count], 2);
    VYNFCNDEFWifiSimpleConfigCredential *credential0 = parsedPayload.credentials.firstObject;
    XCTAssertTrue([credential0.ssid isEqualToString:@"WLAN-X66666"]);
    XCTAssertTrue([credential0.macAddress isEqualToString:@"c4:f0:81:83:0a:14"]);
    XCTAssertEqual(credential0.networkIndex, 0);
    XCTAssertTrue([credential0.networkKey isEqualToString:@"1358455229043333"]);
    XCTAssertEqual(credential0.authType, VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal);
    XCTAssertEqual(credential0.encryptType, VYNFCNDEFWifiSimpleConfigEncryptTypeAes);
    VYNFCNDEFWifiSimpleConfigCredential *credential1 = parsedPayload.credentials.lastObject;
    XCTAssertTrue([credential1.ssid isEqualToString:@"WLAN-X66666"]);
    XCTAssertTrue([credential1.macAddress isEqualToString:@"c4:f0:81:83:0a:17"]);
    XCTAssertEqual(credential1.networkIndex, 0);
    XCTAssertTrue([credential1.networkKey isEqualToString:@"1358455229043333"]);
    XCTAssertEqual(credential1.authType, VYNFCNDEFWifiSimpleConfigAuthTypeWpa2Personal);
    XCTAssertEqual(credential1.encryptType, VYNFCNDEFWifiSimpleConfigEncryptTypeAes);
    XCTAssertNil(parsedPayload.version2);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
