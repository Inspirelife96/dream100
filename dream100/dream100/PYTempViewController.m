//
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//

#import "PYTempViewController.h"

#import "ILFriendListCell.h"
#import "ILUserProfileDelegate.h"
#import "ILUserDreamViewController.h"
#import "DemoMessagesViewController.h"

@interface PYTempViewController () <UITableViewDelegate, UITableViewDataSource, ILUserProfileDefaultViewDelegate, ILFriendListCellDelegate>

@end

@implementation PYTempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索结果";
    
    self.userTableView.dataSource = self;
    self.userTableView.delegate = self;
    self.userTableView.tableFooterView = [[UIView alloc] init];
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
    return self.searchResultArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ILFriendListCell *userSimpleCell = [tableView dequeueReusableCellWithIdentifier:@"ILFriendListCell" forIndexPath:indexPath];
    userSimpleCell.delegate = self;
    userSimpleCell.userObject = (AVUser *)self.searchResultArray[indexPath.row];
    userSimpleCell.messageButton.tag = indexPath.row;
    userSimpleCell.followButton.tag = indexPath.row;

    return userSimpleCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 64.0f;
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


@end
