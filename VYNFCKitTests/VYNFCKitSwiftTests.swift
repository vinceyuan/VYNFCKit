//
//  VYNFCKitSwiftTests.swift
//  VYNFCKitTests
//
//  Created by Vince Yuan on 7/8/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import XCTest
import VYNFCKit
import CoreNFC

class VYNFCKitSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTextPayload() {
        let payloadEn = VYNFCKitTestsHelper.correctTextPayloadEnglish()
        let parsedPayloadEnUntyped = VYNFCNDEFPayloadParser.parse(payloadEn)
        XCTAssertNotNil(parsedPayloadEnUntyped)
        XCTAssert(parsedPayloadEnUntyped is VYNFCNDEFPayloadText)
        let parsedPayloadEn = parsedPayloadEnUntyped as! VYNFCNDEFPayloadText
        XCTAssert(parsedPayloadEn.langCode == "en")
        XCTAssert(parsedPayloadEn.text == "This is text.")

        let payloadCn = VYNFCKitTestsHelper.correctTextPayloadChinese()
        let parsedPayloadCnUntyped = VYNFCNDEFPayloadParser.parse(payloadCn)
        XCTAssertNotNil(parsedPayloadCnUntyped)
        XCTAssert(parsedPayloadCnUntyped is VYNFCNDEFPayloadText)
        let parsedPayloadCn = parsedPayloadCnUntyped as! VYNFCNDEFPayloadText
        XCTAssert(parsedPayloadCn.langCode == "cn")
        XCTAssert(parsedPayloadCn.text == "你好hello")

    }

    func testURIPayload() {
        let payload = VYNFCKitTestsHelper.correctURIPayload()
        let parsedPayloadUntyped = VYNFCNDEFPayloadParser.parse(payload)
        XCTAssertNotNil(parsedPayloadUntyped)
        XCTAssert(parsedPayloadUntyped is VYNFCNDEFPayloadURI)
        let parsedPayload = parsedPayloadUntyped as! VYNFCNDEFPayloadURI
        XCTAssert(parsedPayload.uriString == "https://example.com")
    }

    func testTextXVCardPayload() {
        let payload = VYNFCKitTestsHelper.correctTextXVCardPayload()
        let parsedPayloadUntyped = VYNFCNDEFPayloadParser.parse(payload)
        XCTAssertNotNil(parsedPayloadUntyped)
        XCTAssert(parsedPayloadUntyped is VYNFCNDEFPayloadTextXVCard)
        let parsedPayload = parsedPayloadUntyped as! VYNFCNDEFPayloadTextXVCard
        XCTAssert(parsedPayload.text == "BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
