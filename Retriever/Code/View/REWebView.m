//
//  REWebView.m
//  Retriever
//
//  Created by cyan on 22/11/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "REWebView.h"

static const CGFloat kREScreenEdgeInset = 32;

@interface UIView (Extension)

@end

@implementation UIView (Extension)

- (UIView *)superviewWithClass:(Class)clazz {
    UIView *view = self;
    while (view) {
        if ([view isKindOfClass:clazz]) {
            return view;
        }
        view = view.superview;
    }
    return nil;
}

@end

@implementation REWebView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    UIView *webView = [view superviewWithClass:[WKWebView class]];
    if (webView) {
        webView.userInteractionEnabled = point.x > kREScreenEdgeInset;
    }
    return view;
}

@end
