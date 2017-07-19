# VYNFCKit

VYNFCKit is an iOS library used to parse Near Field Communication (NFC) NDEF message payload.

NDEF (NFC Data Exchange Format) is a standardized data format specification by the NFC Forum which is used to describe how a set of actions are to be encoded onto a NFC tag or to be exchanged between two active NFC devices. The vast majority of NFC enabled devices (readers, phones, tablets…) support reading NDEF messages from NFC tags. On iPhone 7 and iPhone 7 plus with iOS 11, the third-party apps can read NFC tags. _Using Core NFC, you can read Near Field Communication (NFC) tags of types 1 through 5 that contain data in the NFC Data Exchange Format (NDEF)._ An NDEF message consists of header and payload. Core NFC parses message header, but does not parse message payload. This library **VYNFCKit** parses NFC NDEF message payload for you. It supports Objective-c and Swift.

## Supported payload types

Currently VYNFCKit supports the following  Well Known Type which is most widely used:

1. Text with UTF-8 or UTF-16 encoding, e.g. Hello World.
1. Uniform Resource Identifier (URI) with 36 schemes, such as http://, https://,  tel:, mailto:, ftp://, file://,  e.g. https://example.com, tel:5551236666
1. Smart poster. Smart poster is a special kind of NDEF Message, it is a wrapper for other message types. VYNFCKit supports

## Not yet supported payload type

1. Any types other than Well Known Type.

## How to use

Install with cocoapods.

```
#import <VYNFCKit/VYNFCKit.h>

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            id parsedPayload = [VYNFCNDEFPayloadParser parse:payload];
            if (parsedPayload) {
                NSString *text = @"";
                if ([parsedPayload isKindOfClass:[VYNFCNDEFTextPayload class]]) {
                    text = ((VYNFCNDEFTextPayload *)parsedPayload).text;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFURIPayload class]]) {
                    text = ((VYNFCNDEFURIPayload *)parsedPayload).URIString;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFTextXVCardPayload class]]) {
                    text = ((VYNFCNDEFTextXVCardPayload *)parsedPayload).text;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFSmartPosterPayload class]]) {
                    VYNFCNDEFSmartPosterPayload *sp = parsedPayload;
                    for (VYNFCNDEFTextPayload *textPayload in sp.payloadTexts) {
                        text = [NSString stringWithFormat:@"%@%@\n", text, textPayload.text];
                    }
                    text = [NSString stringWithFormat:@"%@%@", text, sp.payloadURI.URIString];
                }
            }
        }
    }
}
```

See example. The objective-c version is available. The swift version will be added later.

## How to contribute

* Star this project.
* Send me pull requests which are welcome. If you make some changes in VYNFCKit.xcodeproj, don't forget to update and run (command+U in Xcode) the unit tests for both objective-c and swift. Please make sure examples also work well.

## Acknowledgement

This post [NFC P2P NDEF Basics](http://austinblackstoneengineering.com/nfc-p2p-basics/) contains a lot of details of NFC NDEF. I learned a lot from it. Some comments in the code are from it too. Many thanks to the author [Austin Blackstone](http://austinblackstoneengineering.com/about/).

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
