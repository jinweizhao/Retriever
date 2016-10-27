//
//  REAppInfoCell.h
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RETableViewCell.h"

@interface REAppInfoCell : RETableViewCell

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType title:(NSString *)title subtitle:(NSString *)subtitle;

@end
