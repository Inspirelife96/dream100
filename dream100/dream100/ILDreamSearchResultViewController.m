//
//  ILDreamSearchResultViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamSearchResultViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "MJRefresh.h"

@interface ILDreamSearchResultViewController ()

@end

@implementation ILDreamSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableViewDataAndRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark others
- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.dreamTableView;
    __unsafe_unretained NSMutableArray *dreamArray = self.dreamObjectArray;

    AVQuery *query = [AVQuery queryWithClassName:@"Dream"];
    [query whereKey:@"content" containsString:_searchText];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [dreamArray removeAllObjects];
            if (objects.count > 0) {
                [dreamArray addObjectsFromArray:objects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                    [tableView.mj_header endRefreshing];
                    [tableView.mj_footer resetNoMoreData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                    [tableView.mj_header endRefreshing];
                    [tableView.mj_footer resetNoMoreData];
                });
            }
        }
    }];
}

- (void)fetchMoreData {
    __unsafe_unretained UITableView *tableView = self.dreamTableView;
    __unsafe_unretained NSMutableArray *dreamArray = self.dreamObjectArray;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Dream"];
    [query whereKey:@"content" containsString:_searchText];
    if (dreamArray.count > 0) {
        AVObject *lastObject = dreamArray[dreamArray.count - 1];
        [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
    }
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            if (objects.count > 0) {
                [dreamArray addObjectsFromArray:objects];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                    [tableView.mj_footer endRefreshing];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                });
            }
        }
    }];
}

@end
