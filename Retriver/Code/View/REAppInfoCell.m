//
//  REAppInfoCell.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppInfoCell.h"

@implementation REAppInfoCell

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType title:(NSString *)title subtitle:(NSString *)subtitle {
    self.accessoryType = accessoryType;
    self.textLabel.text = title;
    self.detailTextLabel.text = subtitle;
}

@end
