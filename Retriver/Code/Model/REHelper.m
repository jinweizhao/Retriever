//
//  REHelper.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REHelper.h"

static NSString *const kRERetriverGitHubURL = @"https://github.com/cyanzhong/Retriver";

@implementation REHelper

+ (id)defaultWorkspace {
    return [NSClassFromString(@"LSApplicationWorkspace") invoke:@"defaultWorkspace"];
}

+ (NSArray *)installedApplications {
    return [[self defaultWorkspace] invoke:@"allInstalledApplications"];
}

+ (NSArray *)installedPlugins {
    return [[self defaultWorkspace] invoke:@"installedPlugins"];
}

+ (NSString *)displayNameForApplication:(id)app {
    return [([app valueForKeyPath:kREDisplayNameKeyPath] ?: [app valueForKey:kRELocalizedShortNameKey]) description];
}

+ (NSString *)bundleIdentifierForApplication:(id)app {
    return [app valueForKey:@"bundleIdentifier"];
}

+ (UIImage *)iconImageForApplication:(id)app {
    return [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                 arguments:@[[self bundleIdentifierForApplication:app], @(10), @([UIScreen mainScreen].scale)]];
}

+ (id)applicationForIdentifier:(NSString *)identifier {
    return [NSClassFromString(@"LSApplicationProxy") invoke:@"applicationProxyForIdentifier:" args:identifier, nil];
}

+ (NSArray *)applicationsForIdentifiers:(NSArray *)identifiers {
    NSMutableArray *apps = [NSMutableArray array];
    for (NSString *identifier in identifiers) {
        [apps addObject:[self applicationForIdentifier:identifier]];
    }
    return apps;
}

+ (void)openApplication:(id)app {
    [[self defaultWorkspace] invoke:@"openApplicationWithBundleID:"
                               args:[self bundleIdentifierForApplication:app], nil];
}

+ (void)openGitHub {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRERetriverGitHubURL]
                                       options:@{}
                             completionHandler:nil];
}

+ (void)shareRetriver {
    NSArray *items = @[[NSURL URLWithString:kRERetriverGitHubURL], [UIImage imageNamed:@"AppIcon60x60@3x.png"], @"Retriver: Retrive InfoPlist without Jailbreak on iOS Devices"];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller
                                                                                     animated:YES
                                                                                   completion:nil];
}

@end
