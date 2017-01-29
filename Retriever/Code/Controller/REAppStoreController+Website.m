//
//  REAppStoreController+Website.m
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppStoreController+Website.h"
#import "REAppStoreController+Private.h"
#import "REAppStoreController+Affiliate.h"
#import <SafariServices/SafariServices.h>

@implementation REAppStoreController (Website)

- (void)hideWebsite {
    self.safariViewController.view.hidden = YES;
}

- (void)loadWebsite {
    
    [self hideAffiliate];
    
    if (self.safariViewController == nil) {
        // appannie: https://www.appannie.com/apps/ios/app/identifier/details/
        // aso100: https://aso100.com/app/baseinfo/appid/identifier
        NSString *url = [NSString stringWithFormat:@"https://aso100.com/app/baseinfo/appid/%@", self.appIdentifier];
        self.safariViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        [self addChildViewController:self.safariViewController];
        [self.view addSubview:self.safariViewController.view];
        
        [self.safariViewController didMoveToParentViewController:self];
        [self.safariViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(50);
            make.left.bottom.right.equalTo(0);
        }];
    }
    
    self.safariViewController.view.hidden = NO;
}

@end
