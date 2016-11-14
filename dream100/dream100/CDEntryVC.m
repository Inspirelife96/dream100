//
//  CDEntryVC.m
//  LeanChat
//
//  Created by lzw on 15/4/15.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDEntryVC.h"
#import "CDTextField.h"

@interface CDEntryVC () <UITextFieldDelegate>

@property (nonatomic, assign) CGPoint originOffset;

@end

@implementation CDEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    
    
    if (_isIncludeEmailField) {
        [self.view addSubview:self.emailField];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Propertys

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - kEntryVCIconImageViewSize / 2, kEntryVCIconImageViewMarginTop, kEntryVCIconImageViewSize, kEntryVCIconImageViewSize)];
        _iconImageView.image = nil;
    }
    return _iconImageView;
}

- (CDTextField *)usernameField {
    if (_usernameField == nil) {
        _usernameField = [CDTextField textFieldWithPadding:kEntryVCTextFieldPadding];
        _usernameField.frame = CGRectMake(kEntryVCHorizontalSpacing, CGRectGetMaxY(_iconImageView.frame) + kEntryVCUsernameFieldMarginTop, CGRectGetWidth(self.view.frame) - kEntryVCHorizontalSpacing * 2, kEntryVCTextFieldHeight);
        _usernameField.background = [UIImage imageNamed:@"input_bg_top"];
        _usernameField.placeholder = @"用户名";
        _usernameField.font = GetFontAvenirNext(16.0f);
        _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _usernameField.delegate = self;
        _usernameField.returnKeyType = UIReturnKeyNext;
        _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameField.alpha = 0.7;
    }
    return _usernameField;
}

- (CDTextField *)passwordField {
    if (_passwordField == nil) {
        _passwordField = [[CDTextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_usernameField.frame), CGRectGetMaxY(_usernameField.frame), CGRectGetWidth(_usernameField.frame), CGRectGetHeight(_usernameField.frame))];
        if (_isIncludeEmailField) {
            _passwordField.background = [UIImage imageNamed:@"input_bg_bottom"];
        } else {
            _passwordField.background = [UIImage imageNamed:@"input_bg_bottom"];
        }
        _passwordField.horizontalPadding = kEntryVCTextFieldPadding;
        _passwordField.verticalPadding = kEntryVCTextFieldPadding;
        _passwordField.delegate = self;
        _passwordField.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _passwordField.placeholder = @"密码";
        _passwordField.font = GetFontAvenirNext(16.0f);
        _passwordField.secureTextEntry = YES;
        _passwordField.returnKeyType = UIReturnKeyGo;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.alpha = 0.7;

    }
    return _passwordField;
}

- (CDTextField *)emailField {
    if (_emailField == nil) {
        _emailField = [CDTextField textFieldWithPadding:kEntryVCTextFieldPadding];
        _emailField.frame = CGRectMake(CGRectGetMinX(_passwordField.frame), CGRectGetMaxY(_passwordField.frame), CGRectGetWidth(_passwordField.frame), CGRectGetHeight(_passwordField.frame));
        _emailField.background = [UIImage imageNamed:@"input_bg_bottom"];
        _emailField.placeholder = @"邮箱地址";
        _emailField.font = GetFontAvenirNext(16.0f);
        _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailField.delegate = self;
        _emailField.returnKeyType = UIReturnKeyNext;
        _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailField.alpha = 0.7;
    }
    return _emailField;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    
    if (textField == self.passwordField && _isIncludeEmailField) {
        [self.emailField becomeFirstResponder];
    }
    
    return YES;
}

- (void)closeKeyboard:(id)sender {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

@end
