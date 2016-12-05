//
//  ILMyDreamViewController.m
//  dream100
//
//  Created by Chen XueFeng on 2016/11/16.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILMyDreamViewController.h"
#import "UIViewController+Login.h"
#import "XWPublishController.h"

@interface ILMyDreamViewController ()

@end

@implementation ILMyDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"吾愿";
    self.tabBarController.tabBar.hidden = NO;
    
    if ([AVUser currentUser]) {
        self.currentUser = [AVUser currentUser];
        self.userHeaderView.userObject = [AVUser currentUser];
    } else {
        [self.userHeaderView setHidden:YES];
    }
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddDreamBarButton:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"ILUserLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"ILUserLogoutNotification" object:nil];
}

- (void)clickAddDreamBarButton:(UIBarButtonItem *)send {
    if (![self isLogin]) {
        return;
    }
    
    XWPublishController *publishVC = [[XWPublishController alloc] init];
    publishVC.type = 0;
    publishVC.dreamObject = nil;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILUserLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILUserLogoutNotification" object:nil];
}

- (void)login:(id)sender {
    self.currentUser = [AVUser currentUser];
    self.userHeaderView.userObject = [AVUser currentUser];
    [self.userHeaderView setHidden:NO];
    //[self refreshData];
}

- (void)logout:(id)sender {
    self.currentUser = nil;
    [self.userHeaderView setHidden:YES];
    [self.dreamObjectArray removeAllObjects];
    //[self refreshData];
}

@end
