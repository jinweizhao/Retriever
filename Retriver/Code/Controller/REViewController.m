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

typedef NS_ENUM(NSInteger, REListType) {
    REListTypeApp       = 0,
    REListTypePlugin
};

@interface REViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) RETableView *tableView;

@end

@implementation REViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UISegmentedControl alloc] initWithItems:@[@"Apps", @"Plugins"]];
    
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
    switch (sender.selectedSegmentIndex) {
        case REListTypeApp:
            self.apps = [REWorkspace installedApplications];
            break;
        case REListTypePlugin:
            self.apps = [REWorkspace installedPlugins];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)refresh {
    NSArray *apps = [REWorkspace installedApplications];
    NSArray *plugins = [REWorkspace installedPlugins];
    self.apps = apps;
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"Apps (%d)", (int)apps.count]
                  forSegmentAtIndex:REListTypeApp];
    [self.segmentedControl setTitle:[NSString stringWithFormat:@"Plugins (%d)", (int)plugins.count]
                  forSegmentAtIndex:REListTypePlugin];
    self.segmentedControl.selectedSegmentIndex = REListTypeApp;
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSString *)displayNameAtIndexPath:(NSIndexPath *)indexPath {
    id app = self.apps[indexPath.row];
    return [([app valueForKeyPath:kREDisplayNameKeyPath] ?: [app valueForKey:kRELocalizedShortNameKey]) description];
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
    id app = self.apps[indexPath.row];
    id bundle = [app invoke:@"containingBundle"] ?: app;
    cell.imageView.image = [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                                 arguments:@[[bundle valueForKey:@"bundleIdentifier"], @(10), @([UIScreen mainScreen].scale)]];
    cell.imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
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
