//
//  ILCommentBaseViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/30.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILCommentBaseViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *commentInputView;
@property(weak, nonatomic) IBOutlet UITextView *inputTextView;
@property(weak, nonatomic) IBOutlet UIButton *sendButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottom;

@property(assign, nonatomic) BOOL bHiddenUI;

- (IBAction)clickSendButton:(id)sender;

- (void)sendComment;
- (void)updateInputViewUI;

@end
