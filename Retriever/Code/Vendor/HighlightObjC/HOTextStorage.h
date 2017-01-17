//
//  HOTextStorage.h
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOHighlighter.h"

@class HOTextStorage;

@protocol HOHighlightDelegate <NSObject>

@optional

- (BOOL)textStorage:(HOTextStorage *)storage shouldHighlight:(NSRange)range;

- (void)textStorage:(HOTextStorage *)storage didHighlight:(NSRange)range success:(BOOL)success;

@end

@interface HOTextStorage : NSTextStorage

@property (nonatomic, strong) NSMutableAttributedString *storage;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, strong) HOHighlighter *highlighter;
@property (nonatomic, weak) id<HOHighlightDelegate> highlightDelegate;

@end
