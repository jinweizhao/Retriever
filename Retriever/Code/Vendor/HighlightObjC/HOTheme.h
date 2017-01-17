//
//  HOTheme.h
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIColor HOColor;
typedef UIFont HOFont;
typedef NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, id> *> HOThemeInfo;
typedef NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSString *> *> HOThemeStringInfo;

@interface HOTheme : NSObject

@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *lightTheme;
@property (nonatomic, strong) HOFont *font;
@property (nonatomic, strong) HOFont *boldFont;
@property (nonatomic, strong) HOFont *italicFont;
@property (nonatomic, strong) HOThemeInfo *info;
@property (nonatomic, strong) HOThemeStringInfo *strippedInfo;
@property (nonatomic, strong) HOColor *backgroundColor;

- (instancetype)initWithTheme:(NSString *)theme;

- (NSAttributedString *)applyStyles:(NSArray *)styles forText:(NSString *)string;

@end
