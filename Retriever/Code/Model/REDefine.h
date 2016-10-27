//
//  REDefine.h
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#ifndef REDefine_h
#define REDefine_h

#import <UIKit/UIKit.h>

static NSString *const kREPropertyListKeyPath       = @"_infoDictionary.propertyList";
static NSString *const kREDisplayNameKeyPath        = @"_infoDictionary.propertyList.CFBundleDisplayName";
static NSString *const kREPluginPropertyKey         = @"infoPlist";
static NSString *const kRELocalizedShortNameKey     = @"localizedShortName";
static NSString *const kREApplicationProxyClass     = @"LSApplicationProxy";
static NSString *const kREPlugInKitProxyClass       = @"LSPlugInKitProxy";

static inline BOOL isBlankText(NSString *str) {
    if ([str respondsToSelector:@selector(length)]) {
        return (str.length == 0);
    } else {
        return YES;
    }
}

static inline BOOL isNotBlankText(NSString *str) {
    return !(isBlankText(str));
}

static inline NSString *AppDocumentPath(NSString *name) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:name];
}

static inline UIColor *rgba(int r, int g, int b, double a) {
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a];
}

static inline UIColor *rgb(int r, int g, int b) {
    return rgba(r, g, b, 1.0);
}

static inline UIColor *color(int hex) {
    return rgb((double)((hex & 0xff0000) >> 16), (double)((hex & 0xff00) >> 8), (double)(hex & 0xff));
}

#endif /* REDefine_h */
