//
//  CDRegisterController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDRegisterVC.h"
#import "CDEntryActionButton.h"
#import "CDUserManager.h"

@interface CDRegisterVC () 

@property (nonatomic, strong) CDEntryActionButton *registerButton;
//@property (nonatomic, strong) CDTextField *passwordField;

@end

@implementation CDRegisterVC

- (void)viewDidLoad {
    self.isIncludeEmailField = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
    [self.view addSubview:self.registerButton];
    
    self.navigationController.navigationBar.barTintColor = FlatGray;
    self.isIncludeEmailField = YES;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[CDEntryActionButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.emailField.frame), CGRectGetMaxY(self.emailField.frame) + kEntryVCVerticalSpacing, CGRectGetWidth(self.emailField.frame), CGRectGetHeight(self.emailField.frame))];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

#pragma mark - Actions

- (void)registerButtonClicked:(id)sender {
    if (self.usernameField.text.length < USERNAME_MIN_LENGTH || self.passwordField.text.length < PASSWORD_MIN_LENGTH) {
        [self toast:@"用户名或密码至少三位"];
        return;
    }
    [[CDUserManager manager] registerWithUsername:self.usernameField.text phone:nil password:self.passwordField.text block:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            AVInstallation *installation = [AVInstallation currentInstallation];
            [installation setObject:[AVUser currentUser] forKey:@"owner"];
            [installation saveInBackground];
            
            AVObject *dreamCountObject = [AVObject objectWithClassName:@"DreamCount"];
            [dreamCountObject setObject:[AVUser currentUser] forKey:@"user"];
            [dreamCountObject setObject:@(0) forKey:@"count"];
            [dreamCountObject saveEventually];

            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
}

@end
