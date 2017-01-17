
//
//  HOCodeView.m
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "HOCodeView.h"
#import "HOTextStorage.h"
#import "HOTheme.h"
#import "NSString+HO.h"

static const CGFloat kHOCodeViewContentOffsetY = -64;

@implementation HOCodeView

- (instancetype)init {
    
    HOTextStorage *textStorage = [[HOTextStorage alloc] init];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    
    if (self = [super initWithFrame:CGRectZero textContainer:textContainer]) {
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = YES;
        self.editable = NO;
    }
    
    return self;
}

- (void)render:(NSString *)code language:(NSString *)language {
    HOTextStorage *storage = (HOTextStorage *)self.textStorage;
    storage.language = language;
    self.text = code;
    self.contentOffset = CGPointMake(0, kHOCodeViewContentOffsetY);
}

@end
