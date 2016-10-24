//
//  REAppInfoBar.m
//  Retriver
//
//  Created by cyan on 2016/10/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppInfoBar.h"

@interface REAppInfoBar()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleView;

@end

@implementation REAppInfoBar

- (instancetype)initWithInfo:(id)info {
    
    if (self = [super init]) {
        
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
        UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Open"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(open:)];
        self.items = @[spaceItem, openItem];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [REHelper iconImageForApplication:info];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.height.equalTo(self).multipliedBy(0.6);
            make.width.equalTo(_imageView.mas_height);
            make.centerY.equalTo(self);
        }];
        
        _titleView = [[UILabel alloc] init];
        _titleView.text = [REHelper displayNameForApplication:info];
        [self addSubview:_titleView];
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(_imageView.mas_right).offset(10);
        }];
    }
    
    return self;
}

- (void)open:(UIBarButtonItem *)sender {
    if (self.openHandler) {
        self.openHandler();
    }
}

@end
