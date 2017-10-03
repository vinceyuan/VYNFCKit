# VYNFCKit

VYNFCKit is an iOS library used to parse Near Field Communication (NFC) NDEF message payload.

NDEF (NFC Data Exchange Format) is a standardized data format specification by the NFC Forum which is used to describe how a set of actions are to be encoded onto a NFC tag or to be exchanged between two active NFC devices. The vast majority of NFC enabled devices (readers, phones, tablets…) support reading NDEF messages from NFC tags. On iPhone 7 and iPhone 7 plus with iOS 11, the third-party apps can read NFC tags. _Using Core NFC, you can read Near Field Communication (NFC) tags of types 1 through 5 that contain data in the NFC Data Exchange Format (NDEF)._ An NDEF message consists of header and payload. Core NFC parses message header, but does not parse message payload. This library **VYNFCKit** parses NFC NDEF message payload for you. It supports Objective-c and Swift.

![Screenshot](https://github.com/vinceyuan/VYNFCKit/raw/master/ScreenShot.gif)

## Supported payload types

#### Well Known Type

1. Text with UTF-8 or UTF-16 encoding, e.g. Hello World.
1. Uniform Resource Identifier (URI) with 36 schemes, such as http://, https://,  tel:, mailto:, ftp://, file://,  e.g. https://example.com, tel:5551236666
1. Smart poster. Smart poster is a special kind of NDEF Message, it is a wrapper for other message types. VYNFCKit supports

#### Media Type

1. TextXVCard, which contains contact info.
1. Wifi simple configuration.

## How to use

Open your project settings in Xcode, make sure you have chosen a `Team` in General / Signing. Enable Capabilities / Near Field Communication Tag Reading. In Info.plist file, add `Privacy - NFC Scan Usage Description` with string value `NFC Tag`.

You can install `VYNFCKit` with [cocoapods](https://cocoapods.org). Add `pod 'VYNFCKit'` into your Podfile, and then run `pod install`. Open YourProject.xcworkspace with Xcode 9.

You can also install `VYNFCKit` with [Carthage](https://github.com/Carthage/Carthage). Add `github "vinceyuan/VYNFCKit" ~> VERSION_NUMBER_HERE` into your Cartfile, and then run `carthage update`.

#### Swift code

In YourViewController.swift, add

```Swift
import CoreNFC
import VYNFCKit
```
Make YourViewController class conform to `NFCNDEFReaderSessionDelegate`.

```Swift
class YourViewController: UIViewController, NFCNDEFReaderSessionDelegate {
```

Start a NFCNDEFReaderSession.

```Swift
let session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
session.begin()
```

Implement callbacks and parse NFCNDEFPayload with VYNFCKit.

```Swift
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
                urlString = parsedPayload.uriString
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
                for case let credential as VYNFCNDEFWifiSimpleConfigCredential in wifi.credentials {
                    text = String(format: "%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                  text, credential.ssid, credential.networkKey, credential.macAddress,
                                  VYNFCNDEFWifiSimpleConfigCredential.authTypeString(credential.authType),
                                  VYNFCNDEFWifiSimpleConfigCredential.encryptTypeString(credential.encryptType)
                    )
                }
                if let version2 = wifi.version2 {
                    text = String(format: "%@\nVersion2: %@", text, version2.version)
                }
            } else {
                text = "Parsed but unhandled payload type"
            }
            NSLog("%@", text)
        }
    }
}

func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    NSLog("%@", error.localizedDescription)
}
```

See example in Swift: Examples/VYNFCKitExampleSwift.

Usually, you only need `VYNFCNDEFPayloadParser.parse()`. If you need to parse your own Smart Poster message payload, you can use `VYNFCNDEFPayloadParser.parseMessageHeader()` to parse the message header.

#### Objective-C code

In YourViewController.m, add

```Objective-C
#import <CoreNFC/CoreNFC.h>
#import <VYNFCKit/VYNFCKit.h>
```

Make YourViewController class conform to `NFCNDEFReaderSessionDelegate`.

```Objective-C
@interface YourViewController() <NFCNDEFReaderSessionDelegate> {
}
```

Start a NFCNDEFReaderSession.

```Objective-C
NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_get_main_queue() invalidateAfterFirstRead:NO];
    [session beginSession];
```

Implement callbacks and parse NFCNDEFPayload with VYNFCKit.

```Objective-C
#pragma mark - NFCNDEFReaderSessionDelegate

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            id parsedPayload = [VYNFCNDEFPayloadParser parse:payload];
            if (parsedPayload) {
                NSString *text = @"";
                NSString *urlString = nil;
                if ([parsedPayload isKindOfClass:[VYNFCNDEFTextPayload class]]) {
                    text = @"[Text payload]\n";
                    text = [NSString stringWithFormat:@"%@%@", text, ((VYNFCNDEFTextPayload *)parsedPayload).text];
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFURIPayload class]]) {
                    text = @"[URI payload]\n";
                    text = [NSString stringWithFormat:@"%@%@", text, ((VYNFCNDEFURIPayload *)parsedPayload).URIString];
                    urlString = ((VYNFCNDEFURIPayload *)parsedPayload).URIString;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFTextXVCardPayload class]]) {
                    text = @"[TextXVCard payload]\n";
                    text = [NSString stringWithFormat:@"%@%@", text, ((VYNFCNDEFTextXVCardPayload *)parsedPayload).text];
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]) {
                    text = @"[SmartPoster payload]\n";
                    VYNFCNDEFSmartPosterPayload *sp = parsedPayload;
                    for (VYNFCNDEFTextPayload *textPayload in sp.payloadTexts) {
                        text = [NSString stringWithFormat:@"%@%@\n", text, textPayload.text];
                    }
                    text = [NSString stringWithFormat:@"%@%@", text, sp.payloadURI.URIString];
                    urlString = sp.payloadURI.URIString;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFWifiSimpleConfigPayload class]]) {
                    text = @"[WifiSimpleConfig payload]\n";
                    VYNFCNDEFWifiSimpleConfigPayload *wifi = parsedPayload;
                    for (VYNFCNDEFWifiSimpleConfigCredential *credential in wifi.credentials) {
                        text = [NSString stringWithFormat:@"%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                                text, credential.ssid, credential.networkKey, credential.macAddress,
                                [VYNFCNDEFWifiSimpleConfigCredential authTypeString:credential.authType],
                                [VYNFCNDEFWifiSimpleConfigCredential encryptTypeString:credential.encryptType]];
                    }
                    if (wifi.version2) {
                        text = [NSString stringWithFormat:@"%@\nVersion2: %@",
                                text, wifi.version2.version];
                    }
                } else {
                    text = @"Parsed but unhandled payload type";
                }
                NSLog(@"%@", text);
            }
        }
    }
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
    NSLog(@"%@", error);
}
```

See example in Objective-C: Examples/VYNFCKitExampleObjc.

Usually, you only need `[VYNFCNDEFPayloadParser parse:]`. If you need to parse your own Smart Poster message payload, you can use `[VYNFCNDEFPayloadParser parseMessageHeader:length:]` to parse the message header.

## How to contribute

* Star this project.
* Send me pull requests which are welcome. If you make some changes, don't forget to update and run (command+U in Xcode) the unit tests in both objective-c and swift. Please make sure examples also work well.

## Acknowledgement

This post [NFC P2P NDEF Basics](http://austinblackstoneengineering.com/nfc-p2p-basics/) contains a lot of details of NFC NDEF. I learned a lot from it. Some comments in the code are from it too. Many thanks to the author [Austin Blackstone](http://austinblackstoneengineering.com/about/).

## References

* [Wi-Fi Simple Configuration Technical Specification Version 2.0.5](https://www.wi-fi.org/download.php?file=/sites/default/files/private/Wi-Fi_Simple_Configuration_Technical_Specification_v2.0.5.pdf)

## License

### The MIT License (MIT)

Copyright (c) 2017 Aijin Yuan (a.k.a. Vince Yuan)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
