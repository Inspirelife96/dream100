//
//  ILCommentMessageViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILCommentMessageViewController.h"


#import "ILCommentMessageCell.h"
#import "MJRefresh.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIViewController+AlertError.h"
#import "UIViewController+Login.h"
#import "ILDreamDBManager.h"
#import "ILJourneyViewController.h"
#import "ILCommentViewController.h"
#import "ILUserDreamViewController.h"

@interface ILCommentMessageViewController () <UITableViewDataSource, UITableViewDelegate, ILUserProfileDefaultViewDelegate, ILUserProfileWithReplyViewDelegate, ILCommentMessageCellDelegate>

@property(strong, nonatomic) NSMutableArray *commentArray;
@property(strong, nonatomic) AVObject *replyObject;

@end

@implementation ILCommentMessageViewController

- (void)viewDidLoad {
    self.bHiddenUI = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.commentArray = [[NSMutableArray alloc] init];
    
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    self.commentTableView.tableFooterView = [[UIView alloc] init];
    
    [self initTableViewDataAndRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamDBOperationError:) name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyCommentUpdate:) name:@"ILJourneyCommentUpdateNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILJourneyCommentUpdateNotification" object:nil];
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
    return self.commentArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILCommentMessageCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"ILCommentMessageCell" forIndexPath:indexPath];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.delegate = self;
    commentCell.commentObject = self.commentArray[indexPath.row];
    return commentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [ILCommentMessageCell calculateCommentMessageCellHeight:self.commentArray[indexPath.row]];
}

- (void)initTableViewDataAndRefresh {
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.commentTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 下拉刷新
    self.commentTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 上拉刷新
    self.commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self fetchMoreData];
    }];
    
    [self refreshData];
}

- (void)refreshData {
    __unsafe_unretained UITableView *tableView = self.commentTableView;
    __unsafe_unretained NSMutableArray *commentArray = self.commentArray;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
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
    __unsafe_unretained UITableView *tableView = self.commentTableView;
    __unsafe_unretained NSMutableArray *commentArray = self.commentArray;
    
    AVQuery *query = [AVQuery queryWithClassName:@"Comment"];
    [query whereKey:@"toUser" equalTo:[AVUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[AVUser currentUser]];
    [query includeKey:@"fromUser"];
    [query includeKey:@"toUser"];
    [query includeKey:@"journey"];
    [query includeKey:@"journey.dream"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    if (commentArray.count > 0) {
        AVObject *lastObject = commentArray[commentArray.count - 1];
        [query whereKey:@"createdAt" lessThan:lastObject[@"createdAt"]];
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

- (void)clickProfile:(AVUser *)userObject {
    ILUserDreamViewController *userDreamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamVC.currentUser = userObject;
    [self.navigationController pushViewController:userDreamVC animated:YES];
}

- (void)clickReply:(AVObject *)commentObject {
    _replyObject = commentObject;
    [self.commentInputView setHidden:NO];
    [self.commentInputView setUserInteractionEnabled:YES];
    [self.inputTextView becomeFirstResponder];
    self.inputTextView.text = [NSString stringWithFormat:@"@%@: ", commentObject[@"fromUser"][@"username"]];
}

- (void)sendComment {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ILDreamDBManager addComment:self.inputTextView.text toUser:((AVUser *)_replyObject[@"fromUser"]) onJourney:_replyObject[@"journey"]];
}

#pragma mark Notification Handlers
- (void)dreamDBOperationError:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self alertError:nil];
}

- (void)journeyCommentUpdate:(NSNotification*)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.inputTextView.text = @"";
    [self updateInputViewUI];
}

@end
