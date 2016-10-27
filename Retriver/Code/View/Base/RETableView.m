//
//  RETableView.m
//  Retriever
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "RETableView.h"

@implementation RETableView

- (instancetype)init {
    if (self = [super init]) {
        self.tableFooterView = UIView.new;
    }
    return self;
}

@end
