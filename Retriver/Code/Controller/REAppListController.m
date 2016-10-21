//
//  REAppListController.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REAppListController.h"
#import "RETableView.h"
#import "REAppListCell.h"
#import "REAppInfoController.h"

typedef NS_ENUM(NSInteger, REListType) {
    REListTypeApp       = 0,
    REListTypePlugin
};

@interface REAppListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) RETableView *tableView;

@end

@implementation REAppListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UISegmentedControl alloc] initWithItems:@[@"Apps", @"Plugins"]];
    
    self.segmentedControl.selectedSegmentIndex = REListTypeApp;
    [self.segmentedControl addTarget:self 
                              action:@selector(didSegementedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    self.tableView = [[RETableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self refresh];
}

- (UISegmentedControl *)segmentedControl {
    return (UISegmentedControl *)self.navigationItem.titleView;
}

- (void)didSegementedControlValueChanged:(UISegmentedControl *)sender {
    [self refresh];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)refresh {
    
    NSArray *apps = [REWorkspace installedApplications];
    NSArray *plugins = [REWorkspace installedPlugins];
    NSArray *data;
    
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"Apps (%d)", (int)apps.count]
                  forSegmentAtIndex:REListTypeApp];
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"Plugins (%d)", (int)plugins.count]
                  forSegmentAtIndex:REListTypePlugin];
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case REListTypeApp: data = apps; break;
        case REListTypePlugin: data = plugins; break;
        default: break;
    }
    
    self.apps = [data sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *name1 = [REWorkspace displayNameForApplication:obj1];
        NSString *name2 = [REWorkspace displayNameForApplication:obj2];
        return [name1 compare:name2];
    }];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"REHomeCell";
    REAppListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[REAppListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell render:self.apps[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    REAppInfoController *infoController = [[REAppInfoController alloc] initWithInfo:self.apps[indexPath.row]];
    infoController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:infoController animated:YES];
}

@end
