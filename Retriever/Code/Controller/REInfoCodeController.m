//
//  REInfoCodeController.m
//  Retriever
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REInfoCodeController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "REInfoTreeController.h"
#import "REAppInfoBar.h"

typedef NS_ENUM(NSInteger, REInfoCodeType) {
    REInfoCodeTypeJSON      = 0,
    REInfoCodeTypeXML,
    REInfoCodeTypeTree
};

typedef JSValue XMLBeautifier;

@interface REInfoCodeController ()

@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) id info;
@property (nonatomic, strong) id propertyList;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, copy) NSString *json;
@property (nonatomic, copy) NSString *xml;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) XMLBeautifier *beautifier;
@property (nonatomic, assign) REInfoCodeType selectedType;
@property (nonatomic, strong) REAppInfoBar *infoBar;

@end

@implementation REInfoCodeController

- (instancetype)initWithInfo:(id)info {
    if (self = [super init]) {
        _info = info;
    }
    return self;
}

- (UISegmentedControl *)segmentedControl {
    return (UISegmentedControl *)self.navigationItem.titleView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(share:)];
    
    self.navigationItem.titleView = [[UISegmentedControl alloc] initWithItems:@[@"JSON", @"XML", @"Tree"]];
    
    self.segmentedControl.selectedSegmentIndex = REInfoCodeTypeJSON;
    [self.segmentedControl addTarget:self 
                              action:@selector(didSegmentedControlValueChanged:) 
                    forControlEvents:UIControlEventValueChanged];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.webView.scrollView.backgroundColor = self.webView.backgroundColor;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, kREAppInfoBarHeight, 0);
    self.webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.infoBar = [[REAppInfoBar alloc] initWithInfo:self.info];
    [self.view addSubview:self.infoBar];
    [self.infoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(kREAppInfoBarHeight);
    }];
    
    @weakify(self)
    self.infoBar.openHandler = ^{
        @strongify(self)
        [self open];
    };
    
    [self refresh];
}

- (void)open {
    [REHelper openApplication:self.info];
}

- (void)share:(UIBarButtonItem *)sender {
    NSString *path = AppDocumentPath([NSString stringWithFormat:@"%@.plist", self.displayName]);
    [self.propertyList writeToFile:path atomically:YES];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrl]
                                                                                         applicationActivities:nil];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

- (void)didSegmentedControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == REInfoCodeTypeTree) {
        REInfoTreeController *controller = [[REInfoTreeController alloc] initWithInfo:self.info];
        controller.title = self.displayName;
        [self.navigationController pushViewController:controller animated:YES];
        sender.selectedSegmentIndex = self.selectedType;
    } else {
        self.selectedType = sender.selectedSegmentIndex;
        [self refresh];
    }
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
    <meta name='viewport' content='width=device-width'></meta>\
    <link rel='stylesheet' href='theme.css'>\
    <script src='highlight.js'></script>\
    <script>hljs.initHighlightingOnLoad();</script>\
    <style>*{margin:0; padding:0;}</style>\
    <pre><code class='%@'>%@</code></pre>";
    return [NSString stringWithFormat:format, type, code];
}

#pragma mark - Lazy Init

- (id)propertyList {
    if (_propertyList == nil) {
        if ([self.info isKindOfClass:NSClassFromString(kREApplicationProxyClass)]) {
            _propertyList = [self.info valueForKeyPath:kREPropertyListKeyPath];
        } else {
            _propertyList = [self.info valueForKey:kREPluginPropertyKey];
        }
    }
    return _propertyList;
}

- (NSString *)displayName {
    if (_displayName == nil) {
        _displayName = [REHelper displayNameForApplication:self.info];
    }
    return _displayName;
}

- (NSString *)json {
    if (_json == nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.propertyList
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _json = [self wrapCode:json type:@"json"];
    }
    return _json;
}

- (NSString *)xml {
    if (_xml == nil) {
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.propertyList
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

#pragma mark - 3D Touch Menu

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    @weakify(self)
    UIPreviewAction *shareAction = [UIPreviewAction actionWithTitle:@"Share" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        @strongify(self)
        [self share:nil];
    }];
    UIPreviewAction *openAction = [UIPreviewAction actionWithTitle:@"Open" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        @strongify(self)
        [self open];
    }];
    return @[shareAction, openAction];
}

@end
