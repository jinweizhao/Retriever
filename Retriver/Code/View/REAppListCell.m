//
//  REAppListCell.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppListCell.h"

@implementation REAppListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)render:(id)data {
    id bundle = [data invoke:@"containingBundle"] ?: data;
    self.imageView.image = [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                                 arguments:@[[bundle valueForKey:@"bundleIdentifier"], @(10), @([UIScreen mainScreen].scale)]];
    self.textLabel.text = [REHelper displayNameForApplication:data];
}

@end
