//
//  ILPrivateMessageListViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILPrivateMessageListViewController.h"
#import "ILPrivateMessageViewController.h"
#import "ILUserDreamViewController.h"

#import "ILMessageDefaultCell.h"
#import "MJRefresh.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "UIViewController+Login.h"
#import "ILDreamDBManager.h"
#import "DemoMessagesViewController.h"
#import "ILFriendListViewController.h"

@interface ILPrivateMessageListViewController () <UITableViewDataSource, UITableViewDelegate, ILUserProfileDefaultViewDelegate>

@property(strong, nonatomic) NSMutableArray *messageArray;

@end

@implementation ILPrivateMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _messageArray = [[NSMutableArray alloc] init];
    
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *writeMessageBarButton = [[UIBarButtonItem alloc] initWithTitle:@"发私信" style:UIBarButtonItemStylePlain target:self action:@selector(clickWriteBarButton:)];
    
    self.navigationItem.rightBarButtonItem = writeMessageBarButton;
    
    [self initTableViewDataAndRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickWriteBarButton:(id)sender {
    ILFriendListViewController *friendListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILFriendListViewController"];
    [self.navigationController pushViewController:friendListVC animated:YES];
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILMessageDefaultCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"ILMessageDefaultCell" forIndexPath:indexPath];
    messageCell.delegate = self;
    messageCell.messageObject = _messageArray[indexPath.row];
    return messageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    NSString *fromUserId = _messageArray[indexPath.row][@"fromUser"][@"objectId"];
    if ([fromUserId isEqualToString:[AVUser currentUser].objectId]) {
        vc.fromUser = _messageArray[indexPath.row][@"toUser"];
    } else {
        vc.fromUser = _messageArray[indexPath.row][@"fromUser"];
    }
    [self.navigationController pushViewController:vc animated:YES];    
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
    __unsafe_unretained NSMutableArray *messageArray = self.messageArray;
    
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"MessageList"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"MessageList"];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query orderByDescending:@"updatedAt"];
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
    __unsafe_unretained NSMutableArray *messageArray = self.messageArray;
    
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"MessageList"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"MessageList"];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    if (messageArray.count > 0) {
        AVObject *lastObject = messageArray[messageArray.count - 1];
        [query whereKey:@"updatedAt" lessThan:lastObject[@"updatedAt"]];
    }
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query orderByDescending:@"updatedAt"];
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

- (void)clickProfile:(AVUser *)userObject {
    ILUserDreamViewController *userDreamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamVC.currentUser = userObject;
    [self.navigationController pushViewController:userDreamVC animated:YES];
}

@end

