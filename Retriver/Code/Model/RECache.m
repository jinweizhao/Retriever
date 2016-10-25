//
//  RECache.m
//  Retriver
//
//  Created by cyan on 2016/10/25.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RECache.h"

static NSString *const kRECacheFavouriteAppsKey = @"Favourite";

@implementation RECache

+ (NSArray *)favouriteAppIdentifiers {
    NSArray *object = [[NSUserDefaults standardUserDefaults] objectForKey:kRECacheFavouriteAppsKey];
    return object ?: @[];
}

+ (void)setFavouriteAppIdentifiers:(NSArray *)identifiers {
    [[NSUserDefaults standardUserDefaults] setObject:identifiers forKey:kRECacheFavouriteAppsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
