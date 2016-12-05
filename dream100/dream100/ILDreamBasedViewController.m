//
//  ILDreamBasedViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/31.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamBasedViewController.h"
#import "ILJourneyViewController.h"
#import "ILDreamCell.h"
#import "EmptyCell.h"

#import "MJRefresh.h"
#import "SGActionView.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "UIViewController+DreamAction.h"
#import "UIViewController+Login.h"

@interface ILDreamBasedViewController () <UITableViewDelegate, UITableViewDataSource, ILDreamCellDelegate>

@property(assign, nonatomic) BOOL isEmpty;

@end

@implementation ILDreamBasedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dreamTableView.delegate = self;
    _dreamTableView.dataSource = self;
    _dreamTableView.tableFooterView = [[UIView alloc] init];
    
    _dreamObjectArray = [[NSMutableArray alloc] init];
    
    _isEmpty = YES;
}

- (void)initTableViewDataAndRefresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _dreamTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    _dreamTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    
    // 上拉刷新
    _dreamTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_dreamTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dreamObjectArray && _dreamObjectArray.count > 0) {
        _isEmpty = NO;
        return _dreamObjectArray.count;
    } else {
        _isEmpty = YES;
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        emptyCell.emptyLabel.text = @"哇哦，暂时没有发现任何内容，先去别地地方看看吧！";
        return emptyCell;
    } else{
        ILDreamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ILDreamCell" forIndexPath:indexPath];
        cell.dreamObject = _dreamObjectArray[indexPath.row];
        cell.delegate = self;
        cell.actionButton.tag = indexPath.row;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        return  240.0f;
    }
    
    return [ILDreamCell HeightForDreamCell:_dreamObjectArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        return;
    } else {
        ILJourneyViewController *dreamDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILJourneyViewController"];
        dreamDetailVC.dreamObject = _dreamObjectArray[indexPath.row];
        //dreamDetailVC.user = [AVUser currentUser];
        [self.navigationController pushViewController:dreamDetailVC animated:YES];
    }
}

#pragma mark - ILDreamCellDelegate
- (void)selectAction:(id)sender {
    if (![self isLogin]) {
        return;
    }
    
    UIButton *actionButton = (UIButton *)sender;
    [self showActionForDream:_dreamObjectArray[actionButton.tag] onView:actionButton];
}

#pragma mark Notification Handlers
- (void)dreamUIUpdate:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_dreamTableView reloadData];
}

- (void)fetchMoreData {
    // do nothing. overwrite in sub class
}

- (void)refreshData {
    // do nothing. overwrite in sub class
}

@end
