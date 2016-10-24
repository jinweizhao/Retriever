//
//  REInfoCodeController.m
//  Retriver
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REInfoCodeController.h"
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSInteger, REInfoCodeType) {
    REInfoCodeTypeJSON      = 0,
    REInfoCodeTypeXML
};

@interface REInfoCodeController ()

@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) id info;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) WKWebView *webView;

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    switch (self.segmentedControl.selectedSegmentIndex) {
        case REInfoCodeTypeJSON: [self convertToJSON]; break;
        case REInfoCodeTypeXML: [self convertToXML]; break;
        default: break;
    }
    [self.webView loadHTMLString:self.code baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (NSString *)wrapCode:(NSString *)code type:(NSString *)type {
    NSString *format = @"\
    <link rel='stylesheet' href='github.css'>\
    <script src='highlight.pack.js'></script>\
    <script>hljs.initHighlightingOnLoad();</script>\
    <style>*{margin:0; padding:0;}</style>\
    <pre><code class='%@'>%@</code></pre>";
    return [NSString stringWithFormat:format, type, code];
}

- (void)convertToJSON {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.info
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.code = [self wrapCode:json type:@"json"];
}

- (void)convertToXML {
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.info
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:nil];
    NSMutableString *xml = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] mutableCopy];
    [xml replaceOccurrencesOfString:@"<" withString:@"&lt;" options:0 range:NSMakeRange(0, xml.length)];
    [xml replaceOccurrencesOfString:@">" withString:@"&gt;" options:0 range:NSMakeRange(0, xml.length)];
    self.code = [self wrapCode:xml type:@"xml"];
}

@end
