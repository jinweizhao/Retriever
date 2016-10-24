//
//  REInfoCodeController.m
//  Retriver
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REInfoCodeController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSInteger, REInfoCodeType) {
    REInfoCodeTypeJSON      = 0,
    REInfoCodeTypeXML
};

typedef JSValue XMLBeautifier;

@interface REInfoCodeController ()

@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) id info;
@property (nonatomic, copy) NSString *json;
@property (nonatomic, copy) NSString *xml;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) XMLBeautifier *beautifier;

@end

@implementation REInfoCodeController

- (instancetype)initWithAppInfo:(id)info {
    if (self = [super init]) {
        _info = info;
    }
    return self;
}

- (void)done:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UISegmentedControl *)segmentedControl {
    return (UISegmentedControl *)self.navigationItem.titleView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = color(0xF8F8F8);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(done:)];
    
    self.navigationItem.titleView = [[UISegmentedControl alloc] initWithItems:@[@"JSON", @"XML"]];
    
    self.segmentedControl.selectedSegmentIndex = REInfoCodeTypeJSON;
    [self.segmentedControl addTarget:self 
                              action:@selector(didSegmentedControlValueChanged:) 
                    forControlEvents:UIControlEventValueChanged];
    
    // viewport config
    NSString *source = @"\
    var meta = document.createElement('meta');\
    meta.setAttribute('name', 'viewport');\
    meta.setAttribute('content', 'width=device-width');\
    document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *contentController = [[WKUserContentController alloc] init];
    [contentController addUserScript:script];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = contentController;

    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.scrollView.backgroundColor = self.webView.backgroundColor;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self refresh];
}

- (void)didSegmentedControlValueChanged:(UISegmentedControl *)sender {
    [self refresh];
}

- (void)refresh {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *code = self.segmentedControl.selectedSegmentIndex == REInfoCodeTypeJSON ? self.json : self.xml;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:code baseURL:[[NSBundle mainBundle] bundleURL]];
        });
    });
}

- (NSString *)wrapCode:(NSString *)code type:(NSString *)type {
    NSString *format = @"\
    <link rel='stylesheet' href='github.css'>\
    <script src='highlight.pack.js'></script>\
    <script>hljs.initHighlightingOnLoad();</script>\
    <style>*{margin:0; padding:0;} body{background-color: #F8F8F8;}</style>\
    <pre><code class='%@'>%@</code></pre>";
    return [NSString stringWithFormat:format, type, code];
}

#pragma mark - Lazy Init

- (NSString *)json {
    if (_json == nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _json = [self wrapCode:json type:@"json"];
    }
    return _json;
}

- (NSString *)xml {
    if (_xml == nil) {
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.info
                                                                  format:NSPropertyListXMLFormat_v1_0
                                                                 options:0
                                                                   error:nil];
        NSArray *arguments = @[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], @(2)];
        NSString *pretty = [[self.beautifier callWithArguments:arguments] toString];
        NSMutableString *xml = pretty.mutableCopy;
        [xml replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, xml.length)];
        [xml replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, xml.length)];
        _xml = [self wrapCode:xml type:@"xml"];
    }
    return _xml;
}

- (JSValue *)beautifier {
    if (_beautifier == nil) {
        JSContext *context = [[JSContext alloc] init];
        NSString *script = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vkbeautify" ofType:@"js"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        [context evaluateScript:script];
        _beautifier = context[@"beautifier"][@"xml"];
    }
    return _beautifier;
}

@end
