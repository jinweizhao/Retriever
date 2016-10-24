//
//  REAppInfoBar.h
//  Retriver
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kREAppInfoBarHeight = 44.0;

typedef void (^REAppInfoBarOpenHandler)();

@interface REAppInfoBar : UIToolbar

@property (nonatomic, copy) REAppInfoBarOpenHandler openHandler;

- (instancetype)initWithInfo:(id)info;

@end
