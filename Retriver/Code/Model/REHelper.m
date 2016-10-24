//
//  REHelper.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REHelper.h"

static NSString *const kRERetriverGitHubURL = @"https://github.com/cyanzhong/retriver";

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
