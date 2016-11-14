//
//  ILRankingViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/11.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILRankingViewController.h"
#import "ILRankingCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "UIViewController+AlertError.h"
#import "ILUserDreamViewController.h"

@interface ILRankingViewController () <UITableViewDataSource, UITableViewDelegate, ILUserProfileDefaultViewDelegate>

@property(strong, nonatomic) NSMutableArray *dreamRankArray;
@property(strong, nonatomic) NSMutableArray *journeyRankArray;
@property(strong, nonatomic) NSMutableArray *commentRankArray;
@property(strong, nonatomic) NSMutableArray *likeRankArray;
@property(strong, nonatomic) NSArray *rankArray;
@property(strong, nonatomic) NSArray *sectionNameArray;

@end

@implementation ILRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dreamRankArray = [[NSMutableArray alloc] init];
    _journeyRankArray = [[NSMutableArray alloc] init];
    _commentRankArray = [[NSMutableArray alloc] init];
    _likeRankArray = [[NSMutableArray alloc] init];
    _rankArray = @[_dreamRankArray,
                   _journeyRankArray,
                   _commentRankArray,
                   _likeRankArray];
    _sectionNameArray = @[@"梦想家排行榜",
                          @"实践家排行榜",
                          @"评论家排行榜",
                          @"赞美家排行榜"];

    _rankTableView.dataSource = self;
    _rankTableView.delegate = self;
    _rankTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 64.0f)];
    
    self.navigationItem.title = @"排行榜";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _rankArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rankArray[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILRankingCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"ILRankingCell" forIndexPath:indexPath];
    rankCell.rankType = indexPath.section;
    rankCell.countObject = _rankArray[indexPath.section][indexPath.row];
    
    return rankCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVObject *countObject = _rankArray[indexPath.section][indexPath.row];
    
    ILUserDreamViewController *userDreamView = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamView.currentUser = countObject[@"user"];
    [self.navigationController pushViewController:userDreamView animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 64.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionNameArray[section];
}

- (void)refreshData {
    __unsafe_unretained UITableView *tableView = _rankTableView;
    __unsafe_unretained NSMutableArray *dreamRankArray = _dreamRankArray;
    __unsafe_unretained NSMutableArray *journeyRankArray = _journeyRankArray;
    __unsafe_unretained NSMutableArray *commentRankArray = _commentRankArray;
    __unsafe_unretained NSMutableArray *likeRankArray = _likeRankArray;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        AVQuery *query= [AVQuery queryWithClassName:@"DreamCount"];
        [query includeKey:@"user"];
        [query orderByDescending:@"dreamCount"];
        [query setLimit:5];
        NSError *error = nil;
        NSArray *dreamCountArray = [query findObjects:&error];
        if (error) {
            //
        } else {
            [dreamRankArray removeAllObjects];
            [dreamRankArray addObjectsFromArray:dreamCountArray];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        AVQuery *query= [AVQuery queryWithClassName:@"DreamCount"];
        [query includeKey:@"user"];
        [query orderByDescending:@"journeyCount"];
        [query setLimit:5];
        NSError *error = nil;
        NSArray *journeyCountArray = [query findObjects:&error];
        if (error) {
            //
        } else {
            [journeyRankArray removeAllObjects];
            [journeyRankArray addObjectsFromArray:journeyCountArray];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        AVQuery *query= [AVQuery queryWithClassName:@"DreamCount"];
        [query includeKey:@"user"];
        [query orderByDescending:@"commentCount"];
        [query setLimit:5];
        NSError *error = nil;
        NSArray *commentCountArray = [query findObjects:&error];
        if (error) {
            //
        } else {
            [commentRankArray removeAllObjects];
            [commentRankArray addObjectsFromArray:commentCountArray];
        }
    });
    
    dispatch_group_async(group, queue, ^{
        AVQuery *query= [AVQuery queryWithClassName:@"DreamCount"];
        [query includeKey:@"user"];
        [query orderByDescending:@"likeCount"];
        [query setLimit:5];
        NSError *error = nil;
        NSArray *likeCountArray = [query findObjects:&error];
        if (error) {
            //
        } else {
            [likeRankArray removeAllObjects];
            [likeRankArray addObjectsFromArray:likeCountArray];
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [tableView reloadData];
    });
}

- (void)clickProfile:(AVUser *)userObject {
    ILUserDreamViewController *userDreamView = [self.storyboard instantiateViewControllerWithIdentifier:@"ILUserDreamViewController"];
    userDreamView.currentUser = userObject;
    [self.navigationController pushViewController:userDreamView animated:YES];
}

@end
