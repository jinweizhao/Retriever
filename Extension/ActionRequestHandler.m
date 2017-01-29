//
//  ActionRequestHandler.m
//  Extension
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "ActionRequestHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RuntimeInvoker.h"

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    
    void(^loadCompletionHandler)(NSURL *, NSError *) = ^(NSURL *original, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
    
        NSString *encoded = [original.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        NSString *url = [NSString stringWithFormat:@"retriever://open?url=%@", encoded];
        id workspace = [NSClassFromString(@"LSApplicationWorkspace") invoke:@"defaultWorkspace"];
        [workspace invoke:@"openURL:" arguments:@[[NSURL URLWithString:url]]];
    };
    
    NSString *identifier = (NSString *)kUTTypeURL;
    for (NSExtensionItem *item in context.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:identifier]) {
                [itemProvider loadItemForTypeIdentifier:identifier options:nil completionHandler:loadCompletionHandler];
                return;
            }
        }
    }
}

@end
