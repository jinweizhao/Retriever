//
//  HOHighlighter.m
//  HighlightObjC
//
//  Created by cyan on 30/12/2016.
//  Copyright © 2016 cyan. All rights reserved.
//

#import "HOHighlighter.h"
#import "HOTheme.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSString+HO.h"

static NSString *const kHljsObject = @"window.hljs";
static NSString *const kTokenHtmlStart = @"<";
static NSString *const kTokenSpanStart = @"span class=\"";
static NSString *const kTokenSpanStartClose = @"\">";
static NSString *const kTokenSpanEnd = @"/span>";

@interface HOHighlighter()

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSRegularExpression *escapeRegex;

@end

@implementation HOHighlighter

- (NSString *)stringWithFileName:(NSString *)fileName type:(NSString *)type {
    NSString *path = [_bundle pathForResource:fileName ofType:type];
    return [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        
        _context = [[JSContext alloc] init];
        [_context evaluateScript:@"var window = {};"];
        _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            NSLog(@"# JS Exception: %@", exception);
            context.exception = exception;
        };
        
        _bundle = [NSBundle bundleForClass:self.class];
        _escapeRegex = [NSRegularExpression regularExpressionWithPattern:@"&#?[a-zA-Z0-9]+?;"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                   error:nil];
        
        // init js
        NSString *js = [self stringWithFileName:@"highlight" type:@"js"];
        [_context evaluateScript:js];
        
        // set theme
        NSString *css = [self stringWithFileName:@"theme" type:@"css"];
        self.theme = [[HOTheme alloc] initWithTheme:css];
    }
    return self;
}

- (void)setTheme:(HOTheme *)theme {
    _theme = theme;
    if (self.themeChangedHandler) {
        self.themeChangedHandler();
    }
}

- (NSAttributedString *)highlight:(NSString *)code as:(NSString *)lang fastRender:(BOOL)fastRender {
    
    NSString *escaped = [code stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    NSString *command;
    if (lang.length > 0) {
        command = [NSString stringWithFormat:@"%@.highlight(\"%@\",\"%@\").value;", kHljsObject, lang, escaped];
    } else {
        command = [NSString stringWithFormat:@"%@.highlightAuto(\"%@\").value;", kHljsObject, escaped];
    }
   
    NSString *string = [[self.context evaluateScript:command] toString];
    if (string.length > 0) {
        NSAttributedString *result;
        if (fastRender) {
            result = [self renderHTML:string];
        } else {
            string = [NSString stringWithFormat:@"<style>%@</style><pre><code class=\"hljs\">%@</code></pre>", self.theme.lightTheme, string];
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            result = [[NSMutableAttributedString alloc] initWithData:data
                                                             options:options
                                                  documentAttributes:nil
                                                               error:nil];
        }
        return result;
    } else {
        return nil;
    }
}

- (NSAttributedString *)renderHTML:(NSString *)code {
    
    NSScanner *scanner = [NSScanner scannerWithString:code];
    scanner.charactersToBeSkipped = nil;
    
    NSString *token;
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableArray *stack = @[@"hljs"].mutableCopy;
    
    while (!scanner.isAtEnd) {
        
        BOOL ended = NO;
        
        if ([scanner scanUpToString:kTokenHtmlStart intoString:&token]) {
            if (scanner.isAtEnd) {
                ended = YES;
            }
        }
        
        if (token != nil && token.length > 0) {
            [result appendAttributedString:[self.theme applyStyles:stack forText:token]];
            if (ended) {
                continue;
            }
        }
        
        scanner.scanLocation += 1;
        
        NSString *string = scanner.string;
        NSString *next = [string substringWithRange:NSMakeRange(scanner.scanLocation, 1)];
        if ([next isEqualToString:@"s"]) {
            scanner.scanLocation += kTokenSpanStart.length;
            [scanner scanUpToString:kTokenSpanStartClose intoString:&token];
            scanner.scanLocation += kTokenSpanStartClose.length;
            [stack addObject:token];
        } else if([next isEqualToString:@"/"]) {
            scanner.scanLocation += kTokenSpanEnd.length;
            [stack removeLastObject];
        } else {
            [result appendAttributedString:[self.theme applyStyles:stack forText:@"<"]];
            scanner.scanLocation += 1;
        }
        
        token = nil;
    }
    
    NSArray *matches = [self.escapeRegex matchesInString:result.string
                                                 options:NSMatchingReportCompletion
                                                   range:NSMakeRange(0, result.length)];
    NSInteger offset = 0;
    for (NSTextCheckingResult *match in matches) {
        NSRange range = NSMakeRange(match.range.location - offset, match.range.length);
        NSString *entity = [result.string substringWithRange:range];
        NSString *decoded = [entity stringByUnescapingHTML];
        if (decoded.length > 0) {
            [result replaceCharactersInRange:range withString:decoded];
            offset += match.range.length - 1;
        }
    }
    
    return result;
}

@end
