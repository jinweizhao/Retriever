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
#import "REInfoCodeController.h"

typedef NS_ENUM(NSInteger, REListType) {
    REListTypeApp       = 0,
    REListTypePlugin
};

@interface REAppListController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    UISearchResultsUpdating
>

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *filtered;
@property (nonatomic, readonly) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) RETableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation REAppListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UISegmentedControl alloc] initWithItems:@[@"Apps", @"Plugins"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"GitHub" 
                                                                              style:UIBarButtonItemStylePlain 
                                                                             target:self
                                                                             action:@selector(github:)];
    
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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self refresh];
}

- (void)github:(UIBarButtonItem *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/cyanzhong/retriver"]
                                       options:@{}
                             completionHandler:nil];
}

- (UISegmentedControl *)segmentedControl {
    return (UISegmentedControl *)self.navigationItem.titleView;
}

- (void)didSegementedControlValueChanged:(UISegmentedControl *)sender {
    [self refresh];
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (void)refresh {
    
    NSArray *apps = [REHelper installedApplications];
    NSArray *plugins = [REHelper installedPlugins];
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
    
    self.list = [data sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *name1 = [REHelper displayNameForApplication:obj1];
        NSString *name2 = [REHelper displayNameForApplication:obj2];
        return [name1 compare:name2];
    }];
    self.filtered = self.list;
    
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filtered.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"REHomeCell";
    REAppListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[REAppListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell render:self.filtered[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    REInfoCodeController *controller = [[REInfoCodeController alloc] initWithInfo:self.filtered[indexPath.row]];
    self.searchController.active = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Search

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text.lowercaseString;
    if (isBlankText(searchText)) {
        self.filtered = self.list;
        [self.tableView reloadData];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableArray *filtered = [NSMutableArray array];
            for (id item in self.list) {
                NSString *name = [REHelper displayNameForApplication:item];
                if ([name.lowercaseString containsString:searchText]) {
                    [filtered addObject:item];
                }
            }
            self.filtered = filtered;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }
}

@end
