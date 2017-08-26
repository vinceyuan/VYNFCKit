//
//  ViewController.swift
//  VYNFCKitExampleSwift
//
//  Created by Vince Yuan on 8/26/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

import UIKit
import CoreNFC
import VYNFCKit

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {

    var results: String = ""
    @IBOutlet weak var textViewResults: UITextView!
    @IBOutlet weak var switchOpenURI: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapScanNFCTagButton(_ sender: Any) {
        results = ""
        textViewResults.text = ""
        let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for payload in message.records {
                guard let parsedPayload = VYNFCNDEFPayloadParser.parse(payload) else {
                    continue
                }
                var text = ""
                var urlString = ""
                if let parsedPayload = parsedPayload as? VYNFCNDEFTextPayload {
                    text = "[Text payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.text)
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFURIPayload {
                    text = "[URI payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.uriString)
                    urlString = text
                } else if let parsedPayload = parsedPayload as? VYNFCNDEFTextXVCardPayload {
                    text = "[TextXVCard payload]\n"
                    text = String(format: "%@%@", text, parsedPayload.text)
                } else if let sp = parsedPayload as? VYNFCNDEFSmartPosterPayload {
                    text = "[SmartPoster payload]\n"
                    for textPayload in sp.payloadTexts {
                        if let textPayload = textPayload as? VYNFCNDEFTextPayload {
                            text = String(format: "%@%@\n", text, textPayload.text)
                        }
                    }
                    text = String(format: "%@%@", text, sp.payloadURI.uriString)
                    urlString = sp.payloadURI.uriString
                } else if let wifi = parsedPayload as? VYNFCNDEFWifiSimpleConfigPayload {
                    text = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                  text, wifi.credential.ssid, wifi.credential.networkKey, wifi.credential.macAddress,
                                  VYNFCNDEFWifiSimpleConfigCredential.authTypeString(wifi.credential.authType),
                                  VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(wifi.credential.encryptType)
                    )
                    if let version2 = wifi.version2 {
                        text = String(format: "%@\nVersion2: %@", text, version2.version)
                    }
                } else {
                    text = "Parsed but unhandled payload type"
                }
                print(text)

            }
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error)
    }

}

