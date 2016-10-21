//
//  REViewController.m
//  Retriver
//
//  Created by cyan on 2016/10/21.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "REViewController.h"
#import "RETableView.h"
#import "RETableViewCell.h"
#import "REInfoController.h"

@interface REViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) RETableView *tableView;

@end

@implementation REViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[RETableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)refresh {
    self.apps = [[NSClassFromString(@"LSApplicationWorkspace") invoke:@"defaultWorkspace"] invoke:@"allApplications"];
    self.title = [NSString stringWithFormat:@"Retriver (%d)", (int)self.apps.count];
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSString *)displayNameAtIndexPath:(NSIndexPath *)indexPath {
    id app = self.apps[indexPath.row];
    return [app valueForKeyPath:kREDisplayNameKeyPath] ?: [app valueForKey:kRELocalizedShortNameKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"REHomeCell";
    RETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self displayNameAtIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    REInfoController *infoController = [[REInfoController alloc] initWithInfo:self.apps[indexPath.row]];
    infoController.title = [self displayNameAtIndexPath:indexPath];
    [self.navigationController pushViewController:infoController animated:YES];
}

@end
