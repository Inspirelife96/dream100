//
//  ILCommentViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILCommentViewController.h"
#import "CommentSectionHeaderCell.h"
#import "CommentCell.h"
#import "EmptyCell.h"
#import "LikedUserCell.h"
#import "MyLikeCache.h"
#import "ILJourneyCell.h"
#import "MJRefresh.h"
#import "SGActionView.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "MyLikeCache.h"
#import "ILDreamDBManager.h"
#import "UIViewController+AlertError.h"
#import "UIViewController+Login.h"

@interface ILCommentViewController () <UITableViewDataSource, UITableViewDelegate, CommentSectionHeaderCellDelegate, ILJourneyCellDelegate>

@property(strong, nonatomic) ILJourneyCell *journeyCell;

@property(strong, nonatomic) NSMutableArray *commentArray;
@property(strong, nonatomic) NSMutableArray *likeArray;
@property(strong, nonatomic) NSMutableArray *dataForCellArray;

@property(assign, nonatomic) BOOL isEmpty;

@end

@implementation ILCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    _commentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 49.0f)];
    
    _commentArray = [[NSMutableArray alloc] init];
    _likeArray = [[NSMutableArray alloc] init];
    
    _isEmpty = YES;
    _dataForCellArray = _commentArray;
    
    [self initTableViewDataAndFresh];
}

- (void)initTableViewDataAndFresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _commentTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    _commentTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 上拉刷新
    _commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    [self refreshData];
}

- (void)viewWillLayoutSubviews {
    CGFloat journeyCellHeight = [ILJourneyCell HeightForJourneyCell:_journeyObject];
    _journeyCell = [_commentTableView dequeueReusableCellWithIdentifier:@"ILJourneyCell"];
    _journeyCell.delegate = self;
    _journeyCell.journeyObject = _journeyObject;
    [_journeyCell setFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, journeyCellHeight)];
    
    [_commentyHeaderView addSubview:(UIView*)_journeyCell];
    [_commentyHeaderView setFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, journeyCellHeight)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamDBOperationError:) name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyLikeUpdate:) name:@"ILJourneyLikeUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyCommentUpdate:) name:@"ILJourneyCommentUpdateNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILDreamDBOperationErrorNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILJourneyLikeUpdateNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILJourneyCommentUpdateNotification"];
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
    NSInteger numberOfRows = _dataForCellArray.count;

    if (numberOfRows == 0) {
        _isEmpty = YES;
        return 1;
    } else {
        _isEmpty = NO;
        return numberOfRows;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        EmptyCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        emptyCell.emptyLabel.text = @"哇哦，暂时没有发现任何内容，先去别地地方看看吧！";
        return emptyCell;
    } else {
        if (_dataForCellArray == _commentArray) {
            CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
            cell.commentObject = _commentArray[indexPath.row];
            return cell;
        } else {
            LikedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikedUserCell" forIndexPath:indexPath];
            cell.likedUserObject = _likeArray[indexPath.row];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        return 240.0f;
    } else {
        if (_dataForCellArray == _commentArray) {
            return [CommentCell HeightForCommentCell:_dataForCellArray[indexPath.row]];
        } else {
            return 65.0f;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommentSectionHeaderCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"CommentSectionHeaderCell"];
    sectionHeaderView.delegate = self;
    if (_dataForCellArray == _commentArray) {
        [sectionHeaderView setCommentButtonSelected];
    } else {
        [sectionHeaderView setLikeButtonSelected];
    }
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

#pragma mark implement super class method
- (void)sendComment {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ILDreamDBManager addComment:self.inputTextView.text toUser:_journeyObject[@"user"] onJourney:_journeyObject];
}

#pragma mark CommentSectionHeaderCellDelegate
- (void)selectCommentSection:(id)sender {
    _dataForCellArray = _commentArray;
    [_commentTableView reloadData];
    [self refreshData];
}

- (void)selectLikeSection:(id)sender {
    _dataForCellArray = _likeArray;
    [_commentTableView reloadData];
    [self refreshData];
}

#pragma mark ILJourneyCellDelegate
- (void)selectComment:(id)sender {
    if(![self isLogin]) {
        return;
    }
    
    UIButton *commentButton = (UIButton *)sender;
    [commentButton setUserInteractionEnabled:NO];
    
    [self.commentInputView setHidden:NO];
    [self.commentInputView setUserInteractionEnabled:YES];
    [self.inputTextView becomeFirstResponder];
}

- (void)selectLike:(id)sender {
    if(![self isLogin]) {
        return;
    }
    
    UIButton *likeButton = (UIButton *)sender;
    [likeButton setUserInteractionEnabled:NO];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if  ([[MyLikeCache sharedInstance] isLiked:_journeyObject[@"objectId"]]) {
        [ILDreamDBManager removeLike:_journeyObject];
    } else {
        [ILDreamDBManager addLike:_journeyObject];
    }
}

#pragma mark Notification Handlers
- (void)journeyLikeUpdate:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    _journeyCell.journeyObject = _journeyObject;

    if (_dataForCellArray == _likeArray) {
        [self refreshData];
    }
}

- (void)journeyCommentUpdate:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.inputTextView.text = @"";
    [self updateInputViewUI];
    
    _journeyCell.journeyObject = _journeyObject;
    
    if (_dataForCellArray == _commentArray) {
        [self refreshData];
    }
}

- (void)dreamDBOperationError:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [SGActionView showAlertWithTitle:@"操作失败" message:@"貌似您的网络有问题，请确认后再次尝试。" buttonTitle:@"确认" selectedHandle:^(NSInteger index) {
        //
    }];
}

#pragma mark others
- (void)refreshData {
    __unsafe_unretained UITableView *tableView = _commentTableView;
    __unsafe_unretained NSMutableArray *commentArray = nil;
    AVQuery *query = nil;
    
    if (_dataForCellArray == _commentArray) {
        commentArray = _commentArray;
        
        query = [AVQuery queryWithClassName:@"Comment"];
        [query whereKey:@"journey" equalTo:_journeyObject];
        [query includeKey:@"user"];
        [query addDescendingOrder:@"createdAt"];
        [query setLimit:10];
    } else {
        commentArray = _likeArray;
        query = [AVQuery queryWithClassName:@"Like"];
        [query whereKey:@"journey" equalTo:_journeyObject];
        [query includeKey:@"user"];
        [query addDescendingOrder:@"createdAt"];
        [query setLimit:10];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            [commentArray removeAllObjects];
            if (objects.count > 0) {
                [commentArray addObjectsFromArray:objects];
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
    __unsafe_unretained UITableView *tableView = _commentTableView;
    __unsafe_unretained NSMutableArray *commentArray = nil;
    AVQuery *query = nil;
    
    if (_dataForCellArray == _commentArray) {
        commentArray = _commentArray;
        
        query = [AVQuery queryWithClassName:@"Comment"];
        [query whereKey:@"journey" equalTo:_journeyObject];
        if (commentArray.count > 0) {
            AVObject *lastObject = commentArray[commentArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        commentArray = _likeArray;
        
        query = [AVQuery queryWithClassName:@"Like"];
        [query whereKey:@"journey" equalTo:_journeyObject];
        if (commentArray.count > 0) {
            AVObject *lastObject = commentArray[commentArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self alertError:error];
        } else {
            if (objects.count > 0) {
                [commentArray addObjectsFromArray:objects];
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
