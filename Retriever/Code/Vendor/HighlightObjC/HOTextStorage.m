//
//  HOTextStorage.m
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "HOTextStorage.h"

@implementation HOTextStorage

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _storage = [[NSMutableAttributedString alloc] initWithString:@""];
    _highlighter = [[HOHighlighter alloc] init];
    __weak typeof(self) wself = self;
    _highlighter.themeChangedHandler = ^{
        __strong typeof(self) sself = wself;
        [sself highlightAll];
    };
}

- (void)setLanguage:(NSString *)language {
    _language = language;
    [self highlightAll];
}

- (NSString *)string {
    return self.storage.string;
}

- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [self.storage attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self.storage replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
}

- (void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    [self.storage setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

- (void)processEditing {
    [super processEditing];
    if (self.language.length > 0) {
        if (self.editedMask & NSTextStorageEditedCharacters) {
            NSRange range = [self.string paragraphRangeForRange:self.editedRange];
            [self highlight:range];
        }
    }
}

- (void)highlightAll {
    [self highlight:NSMakeRange(0, self.storage.length)];
}

- (void)highlight:(NSRange)range {
    
    if (self.language == nil || self.language.length == 0) {
        return;
    }
    
    if ([self.highlightDelegate respondsToSelector:@selector(textStorage:shouldHighlight:)]) {
        BOOL shouldHighlight = [self.highlightDelegate textStorage:self shouldHighlight:range];
        if (!shouldHighlight) {
            return;
        }
    }
    
    NSString *string = self.string;
    NSString *line = [string substringWithRange:range];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSAttributedString *tmp = [self.highlighter highlight:line as:self.language fastRender:YES];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (range.location + range.length > self.storage.length) {
                if ([self.highlightDelegate respondsToSelector:@selector(textStorage:didHighlight:success:)]) {
                    [self.highlightDelegate textStorage:self didHighlight:range success:NO];
                }
                return;
            }
        
            if (![tmp.string isEqualToString:[self.storage attributedSubstringFromRange:range].string]) {
                if ([self.highlightDelegate respondsToSelector:@selector(textStorage:didHighlight:success:)]) {
                    [self.highlightDelegate textStorage:self didHighlight:range success:NO];
                }
                return;
            }
            
            [self beginEditing];
            [tmp enumerateAttributesInRange:NSMakeRange(0, tmp.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange locr, BOOL * _Nonnull stop) {
                NSRange renderRage = NSMakeRange(range.location + locr.location, locr.length);
                renderRage.length = (renderRage.location + renderRage.length < string.length) ? renderRage.length : string.length - renderRage.location;
                [self.storage setAttributes:attrs range:renderRage];
            }];
            [self endEditing];
            
            [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
            
            if ([self.highlightDelegate respondsToSelector:@selector(textStorage:didHighlight:success:)]) {
                [self.highlightDelegate textStorage:self didHighlight:range success:YES];
            }
        });
    });
}

@end
