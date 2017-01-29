//
//  REAppDelegate+URL.m
//  Retriever
//
//  Created by cyan on 1/29/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "REAppDelegate+URL.h"
#import "REAppStoreController.h"

@implementation REAppDelegate (URL)

- (void)handleURL:(NSURL *)url {
    if ([url.host isEqualToString:@"open"]) {
        NSURLComponents *comps = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
        for (NSURLQueryItem *item in comps.queryItems) {
            if ([item.name isEqualToString:@"url"]) {
                [self loadWithURL:item.value];
                return;
            }
        }
    }
}

- (void)loadWithURL:(NSString *)url {
    REAppStoreController *controller = [[REAppStoreController alloc] initWithURL:url];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    [self.window.rootViewController presentViewController:navigation animated:YES completion:nil];
}

@end
