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
    VYNFCNDEFPayloadParser *_parser;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _parser = [[VYNFCNDEFPayloadParser alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapScanNFCTagButton:(id)sender {
    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_get_main_queue() invalidateAfterFirstRead:NO];
    [session beginSession];
}

#pragma mark - NFCNDEFReaderSessionDelegate

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            VYNFCNDEFPayload *parsedPayload = [_parser parse:payload];
            if (parsedPayload) {
                NSLog(@"%@", parsedPayload.text);
            }
        }
    }
}

- (void)readerSession:(nonnull NFCNDEFReaderSession *)session didInvalidateWithError:(nonnull NSError *)error {
}



@end
