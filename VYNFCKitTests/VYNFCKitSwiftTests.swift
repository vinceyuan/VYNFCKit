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
        let parsedPayloadEn = VYNFCNDEFPayloadParser.parse(payloadEn)
        XCTAssertNotNil(parsedPayloadEn)
        XCTAssertEqual(parsedPayloadEn?.type, .text)
        XCTAssert(parsedPayloadEn?.langCode == "en")
        XCTAssert(parsedPayloadEn?.text == "This is text.")

        let payloadCn = VYNFCKitTestsHelper.correctTextPayloadChinese()
        let parsedPayloadCn = VYNFCNDEFPayloadParser.parse(payloadCn)
        XCTAssertNotNil(parsedPayloadCn)
        XCTAssertEqual(parsedPayloadCn?.type, .text)
        XCTAssert(parsedPayloadCn?.langCode == "cn")
        XCTAssert(parsedPayloadCn?.text == "你好hello")

    }
    
    func testURIPayload() {
        let payload = VYNFCKitTestsHelper.correctURIPayload()
        let parsedPayload = VYNFCNDEFPayloadParser.parse(payload)
        XCTAssertNotNil(parsedPayload)
        XCTAssertEqual(parsedPayload?.type, .URI)
        XCTAssert(parsedPayload?.text == "https://example.com")
    }

    func testTextXVCardPayload() {
        let payload = VYNFCKitTestsHelper.correctTextXVCardPayload()
        let parsedPayload = VYNFCNDEFPayloadParser.parse(payload)
        XCTAssertNotNil(parsedPayload)
        XCTAssertEqual(parsedPayload?.type, .textXVCard)
        XCTAssert(parsedPayload?.text == "BEGIN:VCARD\r\nVERSION:2.1\r\nN:;香港客服;;;\r\nFN:香港客服\r\nTEL;CELL:+85221221188\r\nEND:VCARD")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
