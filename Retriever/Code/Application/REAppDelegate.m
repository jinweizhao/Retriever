//
//  REAppDelegate.m
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppDelegate.h"
#import "REAppDelegate+URL.h"
#import "REAppDelegate+Shortcut.h"
#import "REAppListController.h"

@interface REAppDelegate()

@property (nonatomic, strong) REAppListController *viewController;

@end

@implementation REAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.viewController = REAppListController.new;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.viewController refresh];
}

#pragma mark - URL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self handleURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [self handleURL:url];
    return YES;
}

#pragma mark - Shortcut

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self performActionForShortcutItem:shortcutItem];
}

@end
