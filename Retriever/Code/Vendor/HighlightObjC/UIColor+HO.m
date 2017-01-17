//
//  UIColor+HO.m
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "UIColor+HO.h"

@implementation UIColor (HO)

+ (UIColor *)colorWithCSS:(NSString *)css {
    
    NSString *string = [css stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    } else {
        if ([string isEqualToString:@"white"]) {
            return [UIColor whiteColor];
        } else if ([string isEqualToString:@"black"]) {
            return [UIColor blackColor];
        } else if ([string isEqualToString:@"red"]) {
            return [UIColor redColor];
        } else if ([string isEqualToString:@"green"]) {
            return [UIColor greenColor];
        } else if ([string isEqualToString:@"blue"]) {
            return [UIColor blueColor];
        } else {
            return [UIColor grayColor];
        }
    }
    
    if (string.length != 6 && string.length != 3) {
        return [UIColor grayColor];
    }
    
    unsigned int red = 0, green = 0, blue = 0;
    CGFloat divisor = 255.0;
    
    if (string.length == 6) {
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
        divisor = 255.0;
    } else {
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(0, 1)]] scanHexInt:&red];
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(1, 1)]] scanHexInt:&green];
        [[NSScanner scannerWithString:[string substringWithRange:NSMakeRange(2, 1)]] scanHexInt:&blue];
        divisor = 15.0;
    }
    
    return [UIColor colorWithRed:(red / divisor)
                           green:(green / divisor)
                            blue:(blue / divisor)
                           alpha:1.0];
}

@end
