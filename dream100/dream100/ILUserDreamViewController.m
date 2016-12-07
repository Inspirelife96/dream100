//
//  ILUserDreamViewController.m
//  
//
//  Created by Chen XueFeng on 16/10/4.
//
//

#import "ILUserDreamViewController.h"

#import "MJRefresh.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "ILPrivateMessageViewController.h"
#import "DemoMessagesViewController.h"
#import "UIViewController+Login.h"

@interface ILUserDreamViewController ()<UserHeaderViewDelegate>

@end

@implementation ILUserDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"用户信息";
    _userHeaderView.delegate = self;
    if (_currentUser) {
        _userHeaderView.userObject = _currentUser;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [super initTableViewDataAndRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.dreamTableView;
    __unsafe_unretained NSMutableArray *dreamArray = self.dreamObjectArray;
    
    if (!_currentUser) {
        [self.dreamObjectArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer resetNoMoreData];
        });
        return;
    }
 
    AVQuery *query = [AVQuery queryWithClassName:@"DreamFollow"];
    [query whereKey:@"user" equalTo:_currentUser];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"dream"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [dreamArray removeAllObjects];
            if (objects.count > 0) {
                for (int i = 0; i < objects.count; i++) {
                    AVObject *dreamObject = objects[i][@"dream"];
                    [dreamArray addObject:dreamObject];
                }
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
    
    if (!_currentUser) {
        [self.dreamObjectArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
            [tableView.mj_footer resetNoMoreData];
        });
        return;
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"DreamFollow"];
    [query whereKey:@"user" equalTo:_currentUser];
    if (dreamArray.count > 0) {
        AVObject *lastObject = dreamArray[dreamArray.count - 1];
        [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
    }
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"dream"];
    [query setLimit:10];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            if (objects.count > 0) {
                for (int i = 0; i < objects.count; i++) {
                    AVObject *dreamObject = objects[i][@"dream"];
                    [dreamArray addObject:dreamObject];
                }
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

- (void)followOrUnfollow:(id)sender {
    if (![self isLogin]) {
        return;
    }
}
- (void)sendMessage:(id)sender {
    if (![self isLogin]) {
        return;
    }
    
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    vc.fromUser = _currentUser;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
