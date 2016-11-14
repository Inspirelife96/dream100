//
//  CDLoginController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <LZAlertViewHelper/LZAlertViewHelper.h>

#import "CDLoginVC.h"
#import "CDRegisterVC.h"
//#import "CDAppDelegate.h"
#import "CDEntryBottomButton.h"
#import "CDEntryActionButton.h"
#import "CDBaseNavC.h"
#import "CDSNSView.h"
#import "CDUserManager.h"
#import "AVAnonymousUtils.h"
#import "MyDreamCache.h"
#import "MyLikeCache.h"

@interface CDLoginVC () <CDSNSViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LZAlertViewHelper *alertViewHelper;

@property (nonatomic, strong) CDEntryActionButton *loginButton;
@property (nonatomic, strong) CDEntryBottomButton *registerButton;
@property (nonatomic, strong) CDEntryBottomButton *forgotPasswordButton;
@property (nonatomic, strong) CDSNSView *snsView;

@end

@implementation CDLoginVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    self.isIncludeEmailField = NO;
    [super viewDidLoad];
    
    self.usernameField.placeholder = @"用户名";
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.forgotPasswordButton];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
    [self.view addSubview:self.registerButton];
    self.title = @"注册";
    
    self.navigationController.navigationBar.barTintColor = FlatGray;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
    
    if ([AVUser currentUser]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Propertys

- (CDResizableButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[CDEntryActionButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMaxY(self.passwordField.frame) + kEntryVCVerticalSpacing, CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.usernameField.frame))];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.alpha = 0.7;
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(toRegister:) forControlEvents:UIControlEventTouchUpInside];
        _registerButton.alpha = 0.7;
    }
    return _registerButton;
}

- (UIButton *)forgotPasswordButton {
    if (_forgotPasswordButton == nil) {
        _forgotPasswordButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_forgotPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(toFindPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

- (LZAlertViewHelper *)alertViewHelper {
    if (_alertViewHelper == nil) {
        _alertViewHelper = [[LZAlertViewHelper alloc] init];
    }
    return _alertViewHelper;
}

#pragma mark - Actions
- (void)login:(id)sender {
    if (self.usernameField.text.length < USERNAME_MIN_LENGTH || self.passwordField.text.length < PASSWORD_MIN_LENGTH) {
        [self toast:@"用户名或密码至少三位"];
        return;
    }
    [[CDUserManager manager] loginWithInput:self.usernameField.text password:self.passwordField.text block:^(AVUser *user, NSError *error) {
        if (error) {
            [self showHUDText:error.localizedDescription];
        }
        else {
            if (![[MyDreamCache sharedInstance] cacheMyDream]) {
                //
            }
            
            if (![[MyLikeCache sharedInstance] cacheLiked]) {
                //
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:KEY_USERNAME];
            [self dismissViewControllerAnimated:YES completion:^{
                //
            }];
            
            AVInstallation *installation = [AVInstallation currentInstallation];
            [installation setObject:[AVUser currentUser] forKey:@"owner"];
            [installation saveInBackground];
        }
    }];
}


- (void)toRegister:(id)sender {
    CDBaseVC *nextVC = [[CDRegisterVC alloc] init];;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:nextVC];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark - sns login button clicked

- (BOOL)filterError:(NSError *)error {
    if (error.code == AVOSCloudSNSErrorUserCancel) {
        [self showHUDText:@"取消了登录"];
        return NO;
    }
    return [super filterError:error];
}



@end
