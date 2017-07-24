//
//  ViewController.m
//  VYNFCKitExampleObjc
//
//  Created by Vince Yuan on 7/11/17.
//  Copyright © 2017 Vince Yuan. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>
#import <VYNFCKit/VYNFCKit.h>

@interface ViewController () <NFCNDEFReaderSessionDelegate> {
    NSString *_results;
    __weak IBOutlet UITextView *_textViewResults;
    __weak IBOutlet UISwitch *_switchOpenURI;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapScanNFCTagButton:(id)sender {
    _results = @"";
    _textViewResults.text = @"";
    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_get_main_queue() invalidateAfterFirstRead:NO];
    [session beginSession];
}

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
                    urlString = text;
                } else if ([parsedPayload isKindOfClass:[VYNFCNDEFTextXVCardPayload class]]) {
                    text = @"[TextXVCard payload\n]";
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
                    text = [NSString stringWithFormat:@"%@SSID: %@\nPassword: %@\nMac Address: %@\nAuth Type: %@\nEncrypt Type: %@",
                            text, wifi.credential.ssid, wifi.credential.networkKey, wifi.credential.macAddress,
                            [VYNFCNDEFWifiSimpleConfigCredential authTypeString:wifi.credential.authType],
                            [VYNFCNDEFWifiSimpleConfigCredential encryptTypeString:wifi.credential.encryptType]];
                    if (wifi.version2) {
                        text = [NSString stringWithFormat:@"%@\nVersion2: %@",
                                text, wifi.version2.version];
                    }
                } else {
                    text = @"Parsed but unhandled payload type";
                }
                NSLog(@"%@", text);
                _results = [NSString stringWithFormat:@"%@%@\n", _results, text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _textViewResults.text = _results;

                    if (_switchOpenURI.isOn && urlString) {
                        // Close NFC reader session and open URI after delay. Not all can be opened on iOS.
                        [session invalidateSession];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString] options:@{} completionHandler:nil];
                        });
                    }
                });
            }
        }
    }
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
    NSLog(@"%@", error);
    _results = [NSString stringWithFormat:@"%@%@\n", _results, error];
    dispatch_async(dispatch_get_main_queue(), ^{
        _textViewResults.text = _results;
    });
}



@end
