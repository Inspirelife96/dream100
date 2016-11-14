//
//  ILLikeMessageViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILLikeMessageViewController.h"

#import "ILLikeMessageCell.h"
#import "MJRefresh.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ILJourneyViewController.h"
#import "ILCommentViewController.h"
#import "ILUserDreamViewController.h"
#import "UIViewController+AlertError.h"

@interface ILLikeMessageViewController () <UITableViewDataSource, UITableViewDelegate,ILCommentMessageCellDelegate>

@property(strong, nonatomic) NSMutableArray *likeArray;

@end

@implementation ILLikeMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _likeArray = [[NSMutableArray alloc] init];
    
    _likeTableView.dataSource = self;
    _likeTableView.delegate = self;
    _likeTableView.tableFooterView = [[UIView alloc] init];
    
    [self initTableViewDataAndRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    return _likeArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILLikeMessageCell *likeCell = [tableView dequeueReusableCellWithIdentifier:@"ILLikeMessageCell" forIndexPath:indexPath];
    likeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    likeCell.delegate = self;
    likeCell.likeObject = _likeArray[indexPath.row];
    return likeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [ILLikeMessageCell calculateLikeMessageCellHeight:_likeArray[indexPath.row]];
}

- (void)initTableViewDataAndRefresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _likeTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    _likeTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 上拉刷新
    _likeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    [self refreshData];
}

- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.likeTableView;
    __unsafe_unretained NSMutableArray *likeArray = self.likeArray;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Like"];
    [query whereKey:@"toUser" equalTo:[AVUser currentUser]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query includeKey:@"journey"];
    [query includeKey:@"journey.dream"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [likeArray removeAllObjects];
            if (objects.count > 0) {
                [likeArray addObjectsFromArray:objects];
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
    __unsafe_unretained UITableView *tableView = self.likeTableView;
    __unsafe_unretained NSMutableArray *likeArray = self.likeArray;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Like"];
    [query whereKey:@"toUser" equalTo:[AVUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[AVUser currentUser]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query includeKey:@"journey"];
    [query includeKey:@"journey.dream"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    if (likeArray.count > 0) {
        AVObject *lastObject = likeArray[likeArray.count - 1];
        [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            if (objects.count > 0) {
                [likeArray addObjectsFromArray:objects];
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

- (void)clickDream:(AVObject *)dreamObject {
    ILJourneyViewController *journeyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILJourneyViewController"];
    journeyVC.dreamObject = dreamObject;
    [self.navigationController pushViewController:journeyVC animated:YES];
}

- (void)clickJourney:(AVObject *)journeyObject {
    ILCommentViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILCommentViewController"];
    commentVC.journeyObject = journeyObject;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)clickUser:(AVUser *)userObject {
    ILUserDreamViewController *userDreamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamVC.currentUser = userObject;
    [self.navigationController pushViewController:userDreamVC animated:YES];
}

@end
