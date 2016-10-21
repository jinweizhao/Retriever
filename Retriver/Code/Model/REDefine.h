//
//  REDefine.h
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#ifndef REDefine_h
#define REDefine_h

#import <Foundation/Foundation.h>

static NSString *const kREPropertyListKeyPath       = @"_infoDictionary.propertyList";
static NSString *const kREDisplayNameKeyPath        = @"_infoDictionary.propertyList.CFBundleDisplayName";
static NSString *const kRELocalizedShortNameKey     = @"localizedShortName";

static inline NSString *AppDocumentPath(NSString *name) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:name];
}

#endif /* REDefine_h */
