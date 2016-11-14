//
//  ILFollowMessageViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFollowMessageViewController.h"
#import "ILFollowMessageCell.h"
#import "MJRefresh.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"

#import "ILPrivateMessageViewController.h"

#import "ILUserDreamViewController.h"

@interface ILFollowMessageViewController () <UITableViewDataSource, UITableViewDelegate, ILUserProfileDelegate>

@property(strong, nonatomic) NSMutableArray *followMessageArray;

@end

@implementation ILFollowMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _followMessageArray = [[NSMutableArray alloc] init];
    
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.tableFooterView = [[UIView alloc] init];
    
    [self initTableViewDataAndRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _followMessageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILFollowMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"ILFollowMessageCell" forIndexPath:indexPath];
    messageCell.userObject = _followMessageArray[indexPath.row][@"user"];
    messageCell.followDate = _followMessageArray[indexPath.row][@"createdAt"];
    messageCell.delegate = self;
    messageCell.userButton.tag = indexPath.row;
    return messageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ILPrivateMessageViewController *privateMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILPrivateMessageViewController"];
//    privateMessageVC.userObject = _followMessageArray[indexPath.row][@"followee"];
//    [self.navigationController pushViewController:privateMessageVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 64.0f;
}

- (void)initTableViewDataAndRefresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _messageTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    _messageTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    
    // 上拉刷新
    _messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    
    [self refreshData];
}

- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.messageTableView;
    __unsafe_unretained NSMutableArray *messageArray = self.followMessageArray;
    
    AVQuery *query= [AVQuery queryWithClassName:@"_Followee"];
    [query whereKey:@"followee" equalTo:[AVUser currentUser]];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [messageArray removeAllObjects];
            if (objects.count > 0) {
                [messageArray addObjectsFromArray:objects];
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
    
    __unsafe_unretained UITableView *tableView = self.messageTableView;
    __unsafe_unretained NSMutableArray *messageArray = self.followMessageArray;
    
    AVQuery *query= [AVQuery queryWithClassName:@"_Followee"];
    [query whereKey:@"followee" equalTo:[AVUser currentUser]];
    [query includeKey:@"user"];
    if (messageArray.count > 0) {
        AVObject *lastObject = messageArray[messageArray.count - 1];
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
                [messageArray addObjectsFromArray:objects];
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

- (void)clickUserProfile:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    ILUserDreamViewController *userDreamView = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamView.currentUser = _followMessageArray[selectedButton.tag][@"user"];
    [self.navigationController pushViewController:userDreamView animated:YES];
}

@end
