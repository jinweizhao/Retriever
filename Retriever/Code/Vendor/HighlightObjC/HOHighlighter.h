//
//  HOHighlighter.h
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HOHighlightThemeChangedHandler)();

@class HOTheme;

@interface HOHighlighter : NSObject

@property (nonatomic, strong) HOTheme *theme;
@property (nonatomic, copy) HOHighlightThemeChangedHandler themeChangedHandler;

- (NSAttributedString *)highlight:(NSString *)code as:(NSString *)lang fastRender:(BOOL)fastRender;

@end
