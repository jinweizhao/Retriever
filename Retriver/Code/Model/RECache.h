//
//  RECache.h
//  Retriver
//
//  Created by cyan on 2016/10/25.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RECache : NSObject

+ (NSArray *)favouriteAppIdentifiers;

+ (void)setFavouriteAppIdentifiers:(NSArray *)identifiers;

@end
