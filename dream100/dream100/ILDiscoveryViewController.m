//
//  ILDiscoveryViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDiscoveryViewController.h"
#import "ILDiscoverySectionHeaderCell.h"

#import <BHInfiniteScrollView/BHInfiniteScrollView.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "MJRefresh.h"
#import "SGActionView.h"

#import "UIViewController+AlertError.h"

@interface ILDiscoveryViewController () <BHInfiniteScrollViewDelegate, ILDiscoverySectionHeaderCellDelegate>

@property(strong, nonatomic) NSMutableArray *hotObjectArray;
@property(strong, nonatomic) NSMutableArray *latestObjectArray;
@property(strong, nonatomic) NSMutableArray *followObjectArray;

@end

@implementation ILDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hotObjectArray = [[NSMutableArray alloc] init];
    _latestObjectArray = [[NSMutableArray alloc] init];
    _followObjectArray = [[NSMutableArray alloc] init];
    
    self.dreamObjectArray = _latestObjectArray;

    [self initTableViewDataAndRefresh];
}

- (void)viewWillLayoutSubviews {
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    
    NSArray *imageArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"dreamImage1"],
                           [UIImage imageNamed:@"dreamImage2"],
                           [UIImage imageNamed:@"dreamImage3"],
                           [UIImage imageNamed:@"dreamImage4"],
                           [UIImage imageNamed:@"dreamImage5"],
                           [UIImage imageNamed:@"dreamImage6"],
                           nil];
    
    BHInfiniteScrollView* infinitePageView = [BHInfiniteScrollView
                                              infiniteScrollViewWithFrame:CGRectMake(0, 0, MainScreenWidth, 200.0f) Delegate:self ImagesArray:imageArray];
    
    infinitePageView.pageViewContentMode = UIViewContentModeScaleToFill;
    infinitePageView.imagesArray = imageArray;
    infinitePageView.pageControlAlignmentOffset = CGSizeMake(0, 20);
    infinitePageView.titleView.textColor = [UIColor whiteColor];
    infinitePageView.titleView.margin = 30;
    infinitePageView.titleView.hidden = YES;
    infinitePageView.scrollTimeInterval = 5;
    infinitePageView.autoScrollToNextPage = YES;
    infinitePageView.delegate = self;
    
    [self.headerView addSubview:infinitePageView];
    
    self.navigationItem.title = @"发现";
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ILDiscoverySectionHeaderCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"ILDiscoverySectionHeaderCell"];
    sectionHeaderView.delegate = self;
    if (self.dreamObjectArray == _latestObjectArray) {
        [sectionHeaderView setLatestButtonSelected];
    } else if (self.dreamObjectArray == _hotObjectArray) {
        [sectionHeaderView setHotButtonSelected];
    } else {
        [sectionHeaderView setfollowButtonSelected];
    }
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

#pragma mark ILDiscoverySectionHeaderCellDelegate
- (void)selectHotButton:(id)sender {
    self.dreamObjectArray = _hotObjectArray;
    [self.dreamTableView reloadData];
    [self refreshData];
}

- (void)selectLatestButton:(id)sender {
    self.dreamObjectArray = _latestObjectArray;
    [self.dreamTableView reloadData];
    [self refreshData];
}

- (void)selectFollowButton:(id)sender {
    self.dreamObjectArray = _followObjectArray;
    [self.dreamTableView reloadData];
    [self refreshData];
}

#pragma mark others
- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.dreamTableView;
    __unsafe_unretained NSMutableArray *dreamArray = nil;
    AVQuery *query = nil;
    AVQuery *innerQuery = nil;
    
    if (self.dreamObjectArray == _hotObjectArray) {
        dreamArray = _hotObjectArray;
        
        query = [AVQuery queryWithClassName:@"Dream"];
        [query addDescendingOrder:@"followers"];
        [query addDescendingOrder:@"journeys"];
        [query setLimit:30];
    } else if (self.dreamObjectArray == _latestObjectArray) {
        dreamArray = _latestObjectArray;
        
        query = [AVQuery queryWithClassName:@"Dream"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        dreamArray = _followObjectArray;
        
        innerQuery = [AVUser followeeQuery:@"USER_OBJECT_ID"];
        query = [AVQuery queryWithClassName:@"Dream"];
        [query whereKey:@"user" matchesKey:@"followee" inQuery:innerQuery];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    }
    
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
    __unsafe_unretained NSMutableArray *dreamArray = nil;
    AVQuery *query = nil;
    AVQuery *innerQuery = nil;
    
    if (self.dreamObjectArray == _hotObjectArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_footer endRefreshingWithNoMoreData];
        });
        
        return;
    } else if (self.dreamObjectArray == _latestObjectArray) {
        dreamArray = _latestObjectArray;
        
        query = [AVQuery queryWithClassName:@"Dream"];
        if (dreamArray.count > 0) {
            AVObject *lastObject = dreamArray[dreamArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        dreamArray = _followObjectArray;
        
        innerQuery = [AVUser followeeQuery:@"USER_OBJECT_ID"];
        query = [AVQuery queryWithClassName:@"Dream"];
        if (dreamArray.count > 0) {
            AVObject *lastObject = dreamArray[dreamArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
        [query whereKey:@"user" matchesKey:@"followee" inQuery:innerQuery];
    }
    
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
