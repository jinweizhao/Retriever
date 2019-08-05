//
//  REHelper.m
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REHelper.h"
#import <objc/runtime.h>

static NSString *const kRERetrieverGitHubURL = @"https://github.com/cyanzhong/Retriever";

@implementation REHelper

+ (id)defaultWorkspace {
    return [@"LSApplicationWorkspace" invokeClassMethod:@"defaultWorkspace"];
}

static NSDictionary* appDict = nil;
+ (NSArray *)installedApplications {
    if (@available(iOS 11.0, *)) {
        NSArray *plugins = [self installedPlugins];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        for (id obj in plugins) {
            id p = [obj invoke:@"containingBundle"];
            id k = [p invoke:@"applicationIdentifier"];
            if (p && k) {
                dict[k] = p;
            }
        }
        appDict = dict;
        return dict.allValues;
    }
    else {
        return [[self defaultWorkspace] invoke:@"allInstalledApplications"];
    }
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

+ (UIImage *)iconImageNameForBundleID:(NSString *)bundeID {
    return [[self class] iconImageNameForBundleID:bundeID format:0];
}

+ (UIImage *)iconImageNameForBundleID:(NSString *)bundleID format:(NSInteger)format {
    if (@available(iOS 11.0, *)) {
        id app = appDict[ bundleID ];
        if (app) {
            return [UIImage invoke:@"_iconForResourceProxy:format:" arguments:@[app, @(format)]];
        }
        else {
            return [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                         arguments:@[bundleID, @(format), @([UIScreen mainScreen].scale)]];
        }
    }
    else {
        return [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                     arguments:@[bundleID, @(format), @([UIScreen mainScreen].scale)]];
    }
}

+ (UIImage *)iconImageForApplication:(id)app format:(NSInteger)format {
    return [[self class] iconImageNameForBundleID:[self bundleIdentifierForApplication:app] format:format];
}


+ (UIImage *)iconImageForApplication:(id)app {
    return [[self class] iconImageForApplication:app format:0];
}

+ (id)applicationForIdentifier:(NSString *)identifier {
    return [@"LSApplicationProxy" invokeClassMethod:@"applicationProxyForIdentifier:" args:identifier, nil];
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

+ (void)shareRetriever {
    NSArray *items = @[[NSURL URLWithString:kRERetrieverGitHubURL], [UIImage imageNamed:@"AppIcon60x60@3x.png"], @"Retriever: Retrieve InfoPlist without Jailbreak on iOS Devices"];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                             applicationActivities:nil];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:controller
                                                                                     animated:YES
                                                                                   completion:nil];
}

+ (NSDictionary *)dictForObject:(id)obj {
    return [[self class] getDictForObj:obj class:[obj class]];
}

+ (id)getDictForObj:(id)obj class:(Class)cls {
    
    Class supCls = class_getSuperclass(cls);
    if (!supCls) {
        return NSStringFromClass(cls);
//        return [[self class] dictForObj:app class:cls];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    [dict setObject:[[self class] getDictForObj:obj class:supCls]
             forKey:[NSString stringWithFormat:@"Super - <%@>", NSStringFromClass(supCls)]];
    
    [dict addEntriesFromDictionary:[[self class] dictForObj:obj class:cls]];
    
    return [dict copy];
}

+ (NSMutableDictionary *)dictForObj:(id)app class:(Class)cls {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (NSUInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        [dict setValue:[app valueForKey:key]
                forKey:key];
    }
    free(properties);
    return [dict copy];
}

@end
