//
//  ILJourneyViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILJourneyViewController.h"
#import "ILJourneyCell.h"
#import "DreamCommentCell.h"
#import "JourneyHeaderCell.h"
#import "ILJourneySectionHeaderCell.h"
#import "JoinedUserCell.h"
#import "EmptyCell.h"
#import "DreamContentView.h"
#import "UserInfoView.h"

#import "ILJourneyPublishController.h"
#import "ILCommentViewController.h"
#import "ILUserDreamViewController.h"
#import "ILDreamDBManager.h"
#import "CDLoginVC.h"
#import "CDBaseNavC.h"
#import "SGActionView.h"
#import "MyLikeCache.h"

#import "MJRefresh.h"

#import "UIViewController+DreamAction.h"
#import "UIViewController+AlertError.h" 

#import "UIViewController+Login.h"

@interface ILJourneyViewController () <UITableViewDataSource, UITableViewDelegate, ILJourneyCellDelegate, ILJourneySectionHeaderCellDelegate, ILDreamCellDelegate>

@property(strong, nonatomic) ILDreamCell *dreamCell;

@property(strong, nonatomic) NSMutableArray *hotJourneyArray;
@property(strong, nonatomic) NSMutableArray *latestJourneyArray;
@property(strong, nonatomic) NSMutableArray *myJourneyArray;
@property(strong, nonatomic) NSMutableArray *joinedUserArray;

@property(strong, nonatomic) NSMutableArray *journeyArray;

@property(assign, nonatomic) BOOL isEmpty;

@property(assign, nonatomic) AVObject *selectedJourneyObject;

@end

@implementation ILJourneyViewController

- (void)viewDidLoad {
    
    self.bHiddenUI = YES;
    
    [super viewDidLoad];
    
    _journeyTableView.delegate = self;
    _journeyTableView.dataSource = self;
    _journeyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 64.0f)];
    
    _hotJourneyArray = [[NSMutableArray alloc] init];
    _latestJourneyArray = [[NSMutableArray alloc] init];
    _myJourneyArray = [[NSMutableArray alloc] init];
    _joinedUserArray = [[NSMutableArray alloc] init];
    
    _journeyArray = _hotJourneyArray;
    _isEmpty = YES;
    
    [self initTableDataAndFresh];
}

- (void)initTableDataAndFresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _journeyTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    _journeyTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 上拉刷新
    _journeyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    [self refreshData];
}

- (void)viewWillLayoutSubviews {
    CGFloat dreamContentHeight = [ILDreamCell HeightForDreamCell:_dreamObject];
    _dreamCell = [_journeyTableView dequeueReusableCellWithIdentifier:@"ILDreamCell"];
    _dreamCell.delegate = self;
    _dreamCell.dreamObject = _dreamObject;
    [_dreamCell setFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, dreamContentHeight)];

    [_journeyHeaderView addSubview:(UIView*)_dreamCell];
    [_journeyHeaderView setFrame:CGRectMake(0.0f, 0.0f, MainScreenWidth, dreamContentHeight)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    [_journeyTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamDBOperationError:) name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamUIUpdate:) name:@"ILDreamUIUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyLikeUpdate:) name:@"ILJourneyLikeUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyCommentUpdate:) name:@"ILJourneyCommentUpdateNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILDreamDBOperationErrorNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILDreamUIUpdateNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILJourneyLikeUpdateNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILJourneyCommentUpdateNotification"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = _journeyArray.count;
    
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
        if (_journeyArray == _joinedUserArray) {
            JoinedUserCell *joinedUserCell = [tableView dequeueReusableCellWithIdentifier:@"JoinedUserCell" forIndexPath:indexPath];
            joinedUserCell.selectionStyle = UITableViewCellSelectionStyleNone;
            joinedUserCell.dreamFollowObject = _joinedUserArray[indexPath.row];
            return joinedUserCell;
        } else {
            ILJourneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ILJourneyCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.journeyObject = _journeyArray[indexPath.row];
            cell.delegate = self;
            cell.likeButton.tag = indexPath.row;
            cell.commentButton.tag = indexPath.row;
            cell.userProfileView.userButton.tag = indexPath.row;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isEmpty) {
        return;
    }
    
    if (_journeyArray == _joinedUserArray) {
        ILUserDreamViewController *dreamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
        dreamVC.currentUser = _joinedUserArray[indexPath.row][@"user"];
        [self.navigationController pushViewController:dreamVC animated:YES];
    } else {
        ILCommentViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILCommentViewController"];
        commentVC.journeyObject = _journeyArray[indexPath.row];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEmpty) {
        return  240.0f;
    } else {
        if (_journeyArray == _joinedUserArray) {
            return 64.0f;
        } else {
            return [ILJourneyCell HeightForJourneyCell:_journeyArray[indexPath.row]];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ILJourneySectionHeaderCell *sectionHeaderView = [tableView dequeueReusableCellWithIdentifier:@"ILJourneySectionHeaderCell"];
    sectionHeaderView.delegate = self;
    if (_journeyArray == _hotJourneyArray) {
        [sectionHeaderView setHotJourneyButtonSelected];
    } else if (_journeyArray == _latestJourneyArray) {
        [sectionHeaderView setLatestJourneyButtonSelected];
    } else if (_journeyArray == _myJourneyArray) {
        [sectionHeaderView setMyJourneyButtonSelected];
    } else {
        [sectionHeaderView setJoinedUserButtonSelected];
    }
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (void)clickUser:(id)sender {
    UIButton *button = (UIButton*)sender;
    ILUserDreamViewController *dreamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    AVObject *journeyObject = _hotJourneyArray[[button tag]];
    dreamVC.currentUser = journeyObject[@"user"];
    [self.navigationController pushViewController:dreamVC animated:YES];
}

#pragma mark ILJourneySectionHeaderCellDelegate
- (void)selectHotJourney:(id)sender {
    _journeyArray = _hotJourneyArray;
    [_journeyTableView reloadData];
    [self refreshData];
}
- (void)selectLatestJourney:(id)sender {
    _journeyArray = _latestJourneyArray;
    [_journeyTableView reloadData];
    [self refreshData];
}

- (void)selectMyJourney:(id)sender {
    _journeyArray = _myJourneyArray;
    [_journeyTableView reloadData];
    [self refreshData];
}

- (void)selectJoinedUser:(id)sender {
    _journeyArray = _joinedUserArray;
    [_journeyTableView reloadData];
    [self refreshData];
}

#pragma mark ILJourneyCellDelegate
- (void)selectComment:(id)sender {
    UIButton *button = (UIButton*)sender;
    [button setUserInteractionEnabled:NO];
    _selectedJourneyObject = _journeyArray[button.tag];
    
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

    AVObject *journeyObject = _journeyArray[likeButton.tag];
    if  ([[MyLikeCache sharedInstance] isLiked:journeyObject[@"objectId"]]) {
        [ILDreamDBManager removeLike:journeyObject];
    } else {
        [ILDreamDBManager addLike:journeyObject];
    }
}

#pragma mark ILDreamCellDelegate
- (void)selectAction:(id)sender {
    if(![self isLogin]) {
        return;
    }
    
    [self showActionForDream:_dreamObject onView:sender];
}

#pragma mark implement super class method
- (void)sendComment {
    if(![self isLogin]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ILDreamDBManager addComment:self.inputTextView.text toUser:_selectedJourneyObject[@"user"] onJourney:_selectedJourneyObject];
}

#pragma mark Notification Handlers
- (void)dreamDBOperationError:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertError:nil];
}

- (void)dreamUIUpdate:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _dreamCell.dreamObject = _dreamObject;
    [self refreshData];
}

- (void)journeyLikeUpdate:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_journeyTableView reloadData];
}

- (void)journeyCommentUpdate:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.inputTextView.text = @"";
    [self updateInputViewUI];
    [_journeyTableView reloadData];
}

#pragma mark others
- (void)refreshData {
    if (_journeyArray == _myJourneyArray && ![AVUser currentUser]) {
        [self isLogin];
        [_journeyTableView.mj_header endRefreshing];
        return;
    }
    
    __unsafe_unretained UITableView *tableView = _journeyTableView;
    __unsafe_unretained NSMutableArray *journeyArray = nil;
    AVQuery *query = nil;
    
    if (_journeyArray == _hotJourneyArray) {
        journeyArray = _hotJourneyArray;
        
        query = [AVQuery queryWithClassName:@"Journey"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        [query includeKey:@"user"];
        [query addDescendingOrder:@"commentNumber"];
        [query addDescendingOrder:@"likeNumber"];
        [query addDescendingOrder:@"createdAt"];
        [query setLimit:10];
    } else if (_journeyArray == _latestJourneyArray) {
        journeyArray = _latestJourneyArray;
        
        query = [AVQuery queryWithClassName:@"Journey"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else if (_journeyArray == _myJourneyArray) {
        journeyArray = _myJourneyArray;
        
        query = [AVQuery queryWithClassName:@"Journey"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        journeyArray = _joinedUserArray;
        
        query = [AVQuery queryWithClassName:@"DreamFollow"];
        [query whereKey:@"dream" equalTo:_dreamObject];
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
            [journeyArray removeAllObjects];
            if (objects.count > 0) {
                [journeyArray addObjectsFromArray:objects];
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
    if (_journeyArray == _myJourneyArray && ![AVUser currentUser]) {
        [self isLogin];
        [_journeyTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    __unsafe_unretained UITableView *tableView = _journeyTableView;
    __unsafe_unretained NSMutableArray *journeyArray = nil;
    AVQuery *query = nil;
    
    if (_journeyArray == _hotJourneyArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView.mj_footer endRefreshingWithNoMoreData];
        });
        return;
    } else if (_journeyArray == _latestJourneyArray) {
        journeyArray = _latestJourneyArray;
        
        query = [AVQuery queryWithClassName:@"Journey"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        if (journeyArray.count > 0) {
            AVObject *lastObject = journeyArray[journeyArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];

    } else if (_journeyArray == _myJourneyArray) {
        journeyArray = _myJourneyArray;
        
        query = [AVQuery queryWithClassName:@"Journey"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
        if (journeyArray.count > 0) {
            AVObject *lastObject = journeyArray[journeyArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:10];
    } else {
        journeyArray = _joinedUserArray;
        
        query = [AVQuery queryWithClassName:@"DreamFollow"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        if (journeyArray.count > 0) {
            AVObject *lastObject = journeyArray[journeyArray.count - 1];
            [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
        }
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
            if (objects.count > 0) {
                [journeyArray addObjectsFromArray:objects];
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
