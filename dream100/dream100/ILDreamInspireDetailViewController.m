//
//  ILDreamInspireDetailViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamInspireDetailViewController.h"
#import "ILDreamInspireSectionHeaderCell.h"
#import "ILJourneyViewController.h"
#import "EmptyCell.h"
#import "ILDreamCell.h"
#import "MyDreamCache.h"
#import "SGActionView.h"

#import "MJRefresh.h"
#import "UIViewController+DreamAction.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"

@interface ILDreamInspireDetailViewController () <ILDreamInspireSectionHeaderCellDelegate>

@property(strong, nonatomic) NSMutableArray *suggestObjectArray;
@property(strong, nonatomic) NSMutableArray *latestObjectArray;

@end

@implementation ILDreamInspireDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _suggestObjectArray = [[NSMutableArray alloc] init];
    _latestObjectArray = [[NSMutableArray alloc] init];
    self.dreamObjectArray = _latestObjectArray;
    
    [super initTableViewDataAndRefresh];
}

- (void)viewWillLayoutSubviews {
    self.navigationItem.title = _categoryDict[@"category"];
    NSString *imageString = [NSString stringWithFormat:@"%@W", _categoryDict[@"categoryImage"]];
    _headerImageView.image = [UIImage imageNamed:imageString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ILDreamInspireSectionHeaderCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"ILDreamInspireSectionHeaderCell"];
    sectionHeaderView.delegate = self;
    if (self.dreamObjectArray == _latestObjectArray) {
        [sectionHeaderView setlatestButtonEnable];
    } else {
        [sectionHeaderView setSuggestButtonEnable];
    }
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

#pragma mark ILDreamInspireSectionHeaderCellDelegate
- (void)selectSuggest:(id)sender {
    self.dreamObjectArray = _suggestObjectArray;
    [self.dreamTableView reloadData];
    [self refreshData];
}

- (void)selectLatest:(id)sender {
    self.dreamObjectArray = _latestObjectArray;
    [self.dreamTableView reloadData];
    [self refreshData];
}

#pragma mark others
- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.dreamTableView;
    __unsafe_unretained NSMutableArray *dreamArray = nil;
    AVQuery *query = nil;
    AVQuery *innerQuery = nil;
    
    if (self.dreamObjectArray == _latestObjectArray) {
        dreamArray = _latestObjectArray;
        
        query = [AVQuery queryWithClassName:@"Dream"];
        [query whereKey:@"category" equalTo:_categoryDict[@"category"]];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        dreamArray = _suggestObjectArray;
        
        innerQuery = [AVQuery queryWithClassName:@"_User"];
        [innerQuery whereKey:@"username" equalTo:_categoryDict[@"categoryImage"]];
        query = [AVQuery queryWithClassName:@"Dream"];
        [query whereKey:@"category" equalTo:_categoryDict[@"category"]];
        [query whereKey:@"user" matchesQuery:innerQuery];
        [query orderByDescending:@"followers"];
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
    
    if (self.dreamObjectArray == _latestObjectArray) {
        dreamArray = _latestObjectArray;
        
        query = [AVQuery queryWithClassName:@"Dream"];
        [query whereKey:@"category" equalTo:_categoryDict[@"category"]];
        if (dreamArray.count > 0) {
            AVObject *lastObject = dreamArray[dreamArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_footer endRefreshingWithNoMoreData];
        });
        
        return;
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
