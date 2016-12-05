//
//  ILFriendListViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFriendListViewController.h"

#import "ILFollowMessageCell.h"
#import "MJRefresh.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "NSString+PinYin.h"

#import <PYSearch.h>
#import "PYTempViewController.h"
#import "ILFriendListCell.h"
#import "ILUserProfileDelegate.h"
#import "ILUserDreamViewController.h"

#import "DemoMessagesViewController.h"

@interface ILFriendListViewController () <UITableViewDataSource, UITableViewDelegate, PYSearchViewControllerDelegate, ILUserProfileDefaultViewDelegate, ILFriendListCellDelegate>

@property(strong, nonatomic) NSMutableArray *friendArray;
@property(strong, nonatomic) NSMutableDictionary *friendDict;

@end

@implementation ILFriendListViewController

#pragma mark Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _friendArray = [[NSMutableArray alloc] init];
    _friendDict = [[NSMutableDictionary alloc] init];
    
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;
    _friendTableView.tableFooterView = [[UIView alloc] init];
    
    UIBarButtonItem *searchFriendBarButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearchBarButton:)];
    self.navigationItem.rightBarButtonItem = searchFriendBarButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (_friendType) {
        case ILFriendTypeFollower:
            self.navigationItem.title = @"关注列表";
            break;
        case ILFriendTypeFollowee:
            self.navigationItem.title = @"粉丝列表";
            break;
        case ILFriendTypeBlocked:
            self.navigationItem.title = @"黑名单";
            break;
    }
    
    [self fetchFriedList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _friendArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = _friendArray[section];
    NSMutableArray *array = dict[@"content"];
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _friendArray[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    NSString *friendName = array[indexPath.row];
    AVUser *friendUser = _friendDict[friendName];
    
    ILFriendListCell *friendListCell = [tableView dequeueReusableCellWithIdentifier:@"ILFriendListCell" forIndexPath:indexPath];
    friendListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    friendListCell.delegate = self;
    friendListCell.userObject = friendUser;
    
    return friendListCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 64.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.friendArray[section];
    NSString *title = dict[@"firstLetter"];
    return title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dict in self.friendArray) {
        NSString *title = dict[@"firstLetter"];
        [resultArray addObject:title];
    }
    return resultArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark others
- (void)fetchFriedList {
    switch (_friendType) {
        case ILFriendTypeFollower:
            [self fetchFollowerList];
            break;
        case ILFriendTypeFollowee:
            [self fetchFolloweeList];
            break;
        case ILFriendTypeBlocked:
            [self fetchBlockedList];
            break;
    }
}

- (void)fetchFollowerList {
    __unsafe_unretained UITableView *tableView = self.friendTableView;
    __unsafe_unretained NSMutableArray *friendArray = self.friendArray;
    __unsafe_unretained NSMutableDictionary *friendDict = self.friendDict;
    
    AVQuery *query= [AVQuery queryWithClassName:@"_Followee"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query includeKey:@"followee"];
    [query setLimit:250];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [friendArray removeAllObjects];
            if (objects.count > 0) {
                NSMutableArray *userNameArray = [[NSMutableArray alloc] init];
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AVUser *followeeUser = obj[@"followee"];
                    [userNameArray addObject: followeeUser.username];
                    [friendDict setValue:followeeUser forKey:followeeUser.username];
                }];
                
                [friendArray addObjectsFromArray:[userNameArray arrayWithPinYinFirstLetterFormat]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            } else {
                //
            }
        }
    }];
}

- (void)fetchFolloweeList {
    __unsafe_unretained UITableView *tableView = self.friendTableView;
    __unsafe_unretained NSMutableArray *friendArray = self.friendArray;
    __unsafe_unretained NSMutableDictionary *friendDict = self.friendDict;
    
    AVQuery *query= [AVQuery queryWithClassName:@"_Followee"];
    [query whereKey:@"followee" equalTo:[AVUser currentUser]];
    [query includeKey:@"user"];
    [query setLimit:250];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [friendArray removeAllObjects];
            if (objects.count > 0) {
                NSMutableArray *userNameArray = [[NSMutableArray alloc] init];
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AVUser *followerUser = obj[@"user"];
                    [userNameArray addObject: followerUser.username];
                    [friendDict setValue:followerUser forKey:followerUser.username];
                }];
                
                [friendArray addObjectsFromArray:[userNameArray arrayWithPinYinFirstLetterFormat]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            } else {
                //
            }
        }
    }];
}

- (void)fetchBlockedList {
    __unsafe_unretained UITableView *tableView = self.friendTableView;
    __unsafe_unretained NSMutableArray *friendArray = self.friendArray;
    __unsafe_unretained NSMutableDictionary *friendDict = self.friendDict;
    
    AVQuery *query= [AVQuery queryWithClassName:@"BlockedUser"];
    [query whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [query includeKey:@"toUser"];
    [query setLimit:250];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [friendArray removeAllObjects];
            if (objects.count > 0) {
                NSMutableArray *userNameArray = [[NSMutableArray alloc] init];
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    AVUser *blockedUser = obj[@"toUser"];
                    [userNameArray addObject: blockedUser.username];
                    [friendDict setValue:blockedUser forKey:blockedUser.username];
                }];
                
                [friendArray addObjectsFromArray:[userNameArray arrayWithPinYinFirstLetterFormat]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            } else {
                //
            }
        }
    }];
}

#pragma mark - ILUserProfileDefaultViewDelegate
- (void)clickProfile:(AVUser *)userObject {
    ILUserDreamViewController *userDreamView = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamView.currentUser = userObject;
    [self.navigationController pushViewController:userDreamView animated:YES];
}

#pragma mark - ILFriendListCellDelegate
- (void)clickFollow:(AVUser *)userObject {
    // do nothing?
}

- (void)clickMessage:(AVUser *)userObject {
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    vc.fromUser = userObject;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSearchBarButton:(id)sender {
    // 1.创建热门搜索
    // NSArray *hotSeaches = @[@"一生所愿", @"平凡人的英雄梦", @"环游世界", @"必须掌握的技能", @"充实自我", @"和家人", @"想和TA一起做的事", @"大学里要做的事", @"坚持健身的同学最伟大", @"养生之道", @"必须改掉的坏毛病", @"想读的书单", @"必看的电影", @"我爱的游戏", @"最想要的生日礼物", @"买买买", @"狗狗猫咪", @"创意生活"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"用户名" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AVQuery *query = [AVUser query];
        [query whereKey:@"username" containsString:searchText];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                [self alertError:error];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PYTempViewController *searchResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PYTempViewController"];
                    searchResultVC.searchResultArray = objects;
                    [searchViewController.navigationController pushViewController:searchResultVC animated:YES];
                });
            }
        }];
    }];
    
    searchViewController.searchSuggestionHidden = YES;
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag; // 热门搜索风格为默认
    searchViewController.searchHistoryStyle = PYHotSearchStyleColorfulTag; // 搜索历史风格根据选择
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    [self.navigationController pushViewController:searchViewController animated:YES];
}

@end
