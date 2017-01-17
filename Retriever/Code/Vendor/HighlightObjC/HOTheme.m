//
//  HOTheme.m
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "HOTheme.h"
#import "UIColor+HO.h"

@implementation HOTheme

- (instancetype)initWithTheme:(NSString *)theme {
    if (self = [super init]) {
        
        _theme = theme;
        self.font = [HOFont fontWithName:@"Courier" size:14];
        _strippedInfo = [self stripTheme:theme];
        _lightTheme = [self strippedThemeToString:_strippedInfo];
        _info = [self strippedThemeToTheme:_strippedInfo];
        
        NSString *bkgColorHex = _strippedInfo[@".hljs"][@"background"];
        if (bkgColorHex == nil) {
            bkgColorHex = _strippedInfo[@".hljs"][@"background-color"];
        }
        if (bkgColorHex) {
            if([bkgColorHex isEqualToString:@"white"]) {
                _backgroundColor = [UIColor whiteColor];
            } else if([bkgColorHex isEqualToString:@"black"]) {
                _backgroundColor = [UIColor blackColor];
            } else {
                NSRange range = [bkgColorHex rangeOfString:@"#"];
                _backgroundColor = [UIColor colorWithCSS:[bkgColorHex substringFromIndex:range.location]];
            }
        } else {
            _backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}

- (void)setFont:(HOFont *)font {
    
    _font = font;
    
    UIFontDescriptor *boldDesc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: font.familyName, UIFontDescriptorFaceAttribute: @"Bold"}];
    UIFontDescriptor *italicDesc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: font.familyName, UIFontDescriptorFaceAttribute: @"Italic"}];
    UIFontDescriptor *obliqueDesc = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute: font.familyName, UIFontDescriptorFaceAttribute: @"Oblique"}];
    
    _boldFont = [HOFont fontWithDescriptor:boldDesc size:font.pointSize];
    _italicFont = [HOFont fontWithDescriptor:italicDesc size:font.pointSize];
    
    if (_italicFont == nil || ![_italicFont.familyName isEqualToString:font.familyName]) {
        _italicFont = [HOFont fontWithDescriptor:obliqueDesc size:font.pointSize];
    } else if (_italicFont == nil) {
        _italicFont = font;
    }
    
    if (_boldFont == nil) {
        _boldFont = font;
    }
    
    if (_info != nil) {
        _info = [self strippedThemeToTheme:_strippedInfo];
    }
}

- (NSAttributedString *)applyStyles:(NSArray *)styles forText:(NSString *)string {
    if (styles.count > 0) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = _font;
        for (NSString *style in styles) {
            NSDictionary *theme = _info[style];
            if (theme) {
                [attrs addEntriesFromDictionary:theme];
            }
        }
        return [[NSAttributedString alloc] initWithString:string attributes:attrs];
    } else {
        return [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: _font}];
    }
}

- (HOThemeStringInfo *)stripTheme:(NSString *)theme {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:(\\.[a-zA-Z0-9\\-_]*(?:[, ]\\.[a-zA-Z0-9\\-_]*)*)\\{([^\\}]*?)\\})" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:theme options:NSMatchingReportCompletion range:NSMakeRange(0, theme.length)];
    HOThemeStringInfo *result = [HOThemeStringInfo dictionary];
    
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges == 3) {
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            NSArray *pairs = [[theme substringWithRange:[match rangeAtIndex:2]] componentsSeparatedByString:@";"];
            for (NSString *pair in pairs) {
                NSArray *comps = [pair componentsSeparatedByString:@":"];
                if (comps.count == 2) {
                    attrs[comps[0]] = comps[1];
                }
            }
            if (attrs.count > 0) {
                result[[theme substringWithRange:[match rangeAtIndex:1]]] = attrs;
            }
        }
    }
    
    HOThemeStringInfo *retValue = [HOThemeStringInfo dictionary];
    [result enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary<NSString *,NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *array = [[key stringByReplacingOccurrencesOfString:@" " withString:@","] componentsSeparatedByString:@","];
        for (NSString *item in array) {
            NSMutableDictionary *props = retValue[item];
            if (props == nil) {
                props = [NSMutableDictionary dictionary];
            }
            [props addEntriesFromDictionary:obj];
            retValue[item] = props;
        }
    }];
    
    return retValue;
}

- (NSString *)strippedThemeToString:(HOThemeStringInfo *)info {
    NSMutableString *string = [NSMutableString string];
    [info enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableDictionary<NSString *,NSString *> * _Nonnull props, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@{", key];
        [props enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull css, NSString * _Nonnull val, BOOL * _Nonnull stop) {
            if (![key isEqualToString:@".hljs"] || (![css.lowercaseString isEqualToString:@"background-color"] && ![css.lowercaseString isEqualToString:@"background"])) {
                [string appendFormat:@"%@:%@;", css, val];
            }
        }];
        [string appendString:@"}"];
    }];
    return string;
}

- (HOThemeInfo *)strippedThemeToTheme:(HOThemeStringInfo *)theme {
    
    HOThemeInfo *result = [HOThemeInfo dictionary];
    [theme enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull className, NSMutableDictionary<NSString *,NSString *> * _Nonnull props, BOOL * _Nonnull stop) {
        NSMutableDictionary *keyProps = [NSMutableDictionary dictionary];
        [props enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull prop, BOOL * _Nonnull stop) {
            NSString *attr = [self attributeForCSSKey:key];
            if ([key isEqualToString:@"color"] || [key isEqualToString:@"background-color"]) {
                keyProps[attr] = [self colorForStyle:prop];
            } else if ([key isEqualToString:@"font-style"] || [key isEqualToString:@"font-weight"]) {
                keyProps[attr] = [self fontForStyle:prop];
            }
        }];
        if (keyProps.count > 0) {
            NSString *key = [className stringByReplacingOccurrencesOfString:@"." withString:@""];
            result[key] = keyProps;
        }
    }];

    return result;
}

+ (NSSet *)boldFontSet {
    static dispatch_once_t onceToken;
    static NSSet *set = nil;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithArray:@[@"bold", @"bolder", @"600", @"700", @"800", @"900"]];
    });
    return set;
}

+ (NSSet *)italicFontSet {
    static dispatch_once_t onceToken;
    static NSSet *set = nil;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithArray:@[@"italic", @"oblique"]];
    });
    return set;
}

- (HOFont *)fontForStyle:(NSString *)css {
    
    if ([self.class.boldFontSet containsObject:css]) {
        return _boldFont;
    } else if ([self.class.italicFontSet containsObject:css]) {
        return _italicFont;
    } else {
        return _font;
    }
}

- (UIColor *)colorForStyle:(NSString *)css {
    return [UIColor colorWithCSS:css];
}

- (NSString *)attributeForCSSKey:(NSString *)key {
    
    if ([key isEqualToString:@"color"]) {
        return NSForegroundColorAttributeName;
    }
    
    if ([key isEqualToString:@"font-weight"]) {
        return NSFontAttributeName;
    }
    
    if ([key isEqualToString:@"font-style"]) {
        return NSFontAttributeName;
    }
    
    if ([key isEqualToString:@"background-color"]) {
        return NSBackgroundColorAttributeName;
    }
    
    return NSFontAttributeName;
}

@end
