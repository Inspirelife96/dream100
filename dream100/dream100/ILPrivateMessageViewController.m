//
//  ILPrivateMessageViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILPrivateMessageViewController.h"

#import "ILPrivateMessageCell.h"
#import "MJRefresh.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "UIViewController+Login.h"
#import "ILDreamDBManager.h"

@interface ILPrivateMessageViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *messageArray;

@end

@implementation ILPrivateMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _messageArray = [[NSMutableArray alloc] init];
    
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.tableFooterView = [[UIView alloc] init];
    
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

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILPrivateMessageCell *messageCell = nil;
    if ([_messageArray[indexPath.row][@"fromUser"][@"objectId"] isEqualToString: [AVUser currentUser].objectId]) {
         messageCell = [tableView dequeueReusableCellWithIdentifier:@"ILPrivateMessageCellB" forIndexPath:indexPath];
    } else {
        messageCell = [tableView dequeueReusableCellWithIdentifier:@"ILPrivateMessageCellA" forIndexPath:indexPath];
    }

    messageCell.messageObject = _messageArray[indexPath.row];
    return messageCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [ILPrivateMessageCell HeightForCell:_messageArray[indexPath.row][@"message"]];
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
    
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"Message"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [queryFromMe whereKey:@"toUser" equalTo:_userObject];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"Message"];
    [queryToMe whereKey:@"fromUser" equalTo:_userObject];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
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
    __unsafe_unretained NSMutableArray *messageArray = self.messageArray;
    
    AVQuery *queryFromMe = [AVQuery queryWithClassName:@"Message"];
    [queryFromMe whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [queryFromMe whereKey:@"toUser" equalTo:_userObject];
    
    AVQuery *queryToMe = [AVQuery queryWithClassName:@"Message"];
    [queryToMe whereKey:@"fromUser" equalTo:_userObject];
    [queryToMe whereKey:@"toUser" equalTo:[AVUser currentUser]];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFromMe, queryToMe]];
    if (messageArray.count > 0) {
        AVObject *lastObject = messageArray[messageArray.count - 1];
        [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
    }
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
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

- (void)sendComment {
    if(![self isLogin]) {
        return;
    }
    
    __unsafe_unretained UITableView *tableView = self.messageTableView;
    
    AVObject *messageObject = [AVObject objectWithClassName:@"Message"];
    [messageObject setObject:[AVUser currentUser] forKey:@"fromUser"];
    [messageObject setObject:_userObject forKey:@"toUser"];
    [messageObject setObject:self.inputTextView.text forKey:@"message"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [messageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            //
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
            [ILDreamDBManager AddMessageListFrom:[AVUser currentUser] to:_userObject message:self.inputTextView.text];
        }
    }];
}

@end
