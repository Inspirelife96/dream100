//
//  ILCommentBaseViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/30.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILCommentBaseViewController.h"
#import "UIViewController+Login.h"

@interface ILCommentBaseViewController () <UITextViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation ILCommentBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)]; // 手势类型随你喜欢。
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.bHiddenUI) {
        [self hiddenInputCommentUI];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.bHiddenUI) {
        [self hiddenInputCommentUI];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([_commentInputView isHidden]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tapGesturedDetected:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_inputTextView resignFirstResponder];
        [self sendComment];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (![self isLogin]) {
        return;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateInputViewUI];
}

#pragma mark others
- (void)updateInputViewUI {
    static CGFloat minHeight = 30.0f;
    static CGFloat maxHeight = 80.0f;
    CGSize constraintSize = CGSizeMake(MainScreenWidth - 78.0f, MAXFLOAT);
    CGSize size = [_inputTextView sizeThatFits:constraintSize];
    if (size.height <= minHeight) {
        size.height = minHeight;
    } else {
        if (size.height >= maxHeight) {
            size.height = maxHeight;
            _inputTextView.scrollEnabled = YES;   // 允许滚动
        } else {
            _inputTextView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    _inputTextView.frame = CGRectMake(10.0f, 8.0f, MainScreenWidth - 78.0f, size.height);
    _inputViewHeight.constant = size.height + 16.0f;
}

- (IBAction)clickSendButton:(id)sender {
    [_inputTextView resignFirstResponder];
    if ([_inputTextView.text isEqualToString:@""]) {
        //
    } else {
        [self sendComment];
    }
}

#pragma mark notifications
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 修改工具条底部约束
    _inputViewBottom.constant = MainScreenHeight - keyboardFrame.origin.y;
    
    NSLog(@"%f", _inputViewBottom.constant);
    
    // 获得键盘弹出或隐藏时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 添加动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    _inputViewBottom.constant = 0.0f;
    
    if (self.bHiddenUI) {
        [self hiddenInputCommentUI];
    }
}

- (void)hiddenInputCommentUI {
    [_inputTextView resignFirstResponder];
    [_commentInputView setHidden:YES];
    [_commentInputView setUserInteractionEnabled:NO];
}

@end
