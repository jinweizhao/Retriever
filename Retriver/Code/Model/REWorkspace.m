//
//  REWorkspace.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REWorkspace.h"

@implementation REWorkspace

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

@end
