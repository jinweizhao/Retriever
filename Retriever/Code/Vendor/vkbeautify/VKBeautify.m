//
//  VKBeautify.m
//  Retriever
//
//  Created by cyan on 2/3/17.
//  Copyright © 2017 cyan. All rights reserved.
//

#import "VKBeautify.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface VKBeautify()

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) JSValue *beautifier;

@end

@implementation VKBeautify

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static VKBeautify *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[VKBeautify alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _context = [[JSContext alloc] init];
        
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        NSString *script = [NSString stringWithContentsOfFile:[bundle pathForResource:@"VKBeautify" ofType:@"js"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        [_context evaluateScript:script];
        
        _beautifier = _context[@"beautifier"];
    }
    return self;
}

+ (NSString *)beautified:(NSString *)code type:(VKBeautifySourceType)type {
    
    VKBeautify *instance = [self instance];
    JSValue *beautifier = nil;
    
    switch (type) {
        case VKBeautifySourceTypeJSON: beautifier = instance.beautifier[@"json"]; break;
        case VKBeautifySourceTypeXML: beautifier = instance.beautifier[@"xml"]; break;
        default: break;
    }
    
    return beautifier ? [[beautifier callWithArguments:@[code, @(2)]] toString] : code;
}

@end
