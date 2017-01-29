//
//  REAppStoreController.m
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppStoreController.h"
#import "REAppStoreController+Private.h"
#import "REAppStoreController+Request.h"
#import "REAppStoreController+Affiliate.h"
#import "REAppStoreController+Website.h"
#import "HOCodeView.h"
#import <SafariServices/SafariServices.h>

@implementation REAppStoreController

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self sendRequest];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Affiliate", @"Website"]];
    self.segmentedControl.selectedSegmentIndex = AESegmentTypeAffiliate;
    [self.segmentedControl addTarget:self 
                              action:@selector(handleSegmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(done:)];
    
    self.navigationItem.titleView = self.segmentedControl;
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)startLoading {
    [self.indicatorView startAnimating];
}

- (void)stopLoading {
    [self.indicatorView stopAnimating];
}

- (void)handleSegmentedControlValueChanged:(UISegmentedControl *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (sender.selectedSegmentIndex) {
            case AESegmentTypeAffiliate: [self loadAffiliate]; break;
            case AESegmentTypeWebsite: [self loadWebsite]; break;
            default: break;
        }
    });
}

- (void)done:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
