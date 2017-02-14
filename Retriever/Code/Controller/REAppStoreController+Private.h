//
//  REAppStoreController+Private.h
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppStoreController.h"

@class HOCodeView;
@class SFSafariViewController;

typedef NS_ENUM(NSInteger, AESegmentType) {
    AESegmentTypeAffiliate      = 0,
    AESegmentTypeWebsite
};

@interface REAppStoreController ()

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *appIdentifier;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) HOCodeView *affiliateView;
@property (nonatomic, strong) SFSafariViewController *safariViewController;

- (void)startLoading;

- (void)stopLoading;

- (void)handleSegmentedControlValueChanged:(UISegmentedControl *)sender;

@end
