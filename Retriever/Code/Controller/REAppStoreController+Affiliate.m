//
//  REAppStoreController+Affiliate.m
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppStoreController+Affiliate.h"
#import "REAppStoreController+Private.h"
#import "REAppStoreController+Website.h"
#import "HOCodeView.h"
#import "VKBeautify.h"

@implementation REAppStoreController (Affiliate)

- (void)hideAffiliate {
    self.affiliateView.hidden = YES;
}

- (void)loadAffiliate {

    [self hideWebsite];
    
    if (self.affiliateView == nil) {
        
        self.affiliateView = [[HOCodeView alloc] init];
        self.affiliateView.backgroundColor = self.view.backgroundColor;
        self.affiliateView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        self.affiliateView.scrollIndicatorInsets = self.affiliateView.contentInset;
        [self.view addSubview:self.affiliateView];
        [self.affiliateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self startLoading];
        
        void(^completionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *pretty = [VKBeautify beautified:json type:VKBeautifySourceTypeJSON];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.affiliateView render:pretty language:@"json"];
            });
            [self stopLoading];
        };
        
        NSURL *url = [NSURL URLWithString:[@"https://itunes.apple.com/lookup?id=" stringByAppendingString:self.appIdentifier]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:url]
                                         completionHandler:completionHandler] resume];
    }
    
    self.affiliateView.hidden = NO;
}

@end
