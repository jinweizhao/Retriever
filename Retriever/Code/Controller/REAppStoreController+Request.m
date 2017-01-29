//
//  REAppStoreController+Request.m
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppStoreController+Request.h"
#import "REAppStoreController+Private.h"
#import "REAppStoreController+Affiliate.h"
#import "REAppStoreController+Website.h"

@implementation REAppStoreController (Request)

- (void)sendRequest {
    
    void(^downloadCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
        
        NSString *storeUrl = response.URL.absoluteString;
        NSRange searchedRange = NSMakeRange(0, storeUrl.length);
        NSString *pattern = @"[0-9]{5,}";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:0
                                                                                 error:&error];
        NSArray *matches = [regex matchesInString:storeUrl options:0 range:searchedRange];
        
        for (NSTextCheckingResult *match in matches) {
            NSString *identifier = [storeUrl substringWithRange:match.range];
            [self reloadWithAppIdentifier:identifier];
            break;
        }
    };
    
    NSString *path = [[self.url stringByReplacingOccurrencesOfString:@"https://appsto.re"
                                                          withString:@""] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:[@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/redirectToContent?path=" stringByAppendingString:path]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:url]
                                     completionHandler:downloadCompletionHandler] resume];
    
    [self startLoading];
}

- (void)reloadWithAppIdentifier:(NSString *)identifier {
    self.appIdentifier = identifier;
    [self handleSegmentedControlValueChanged:self.segmentedControl];
    [self stopLoading];
}

@end
