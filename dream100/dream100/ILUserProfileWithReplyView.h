//
//  ILUserProfileWithReplyView.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDefaultView.h"
#import "ILUserProfileDelegate.h"

@interface ILUserProfileWithReplyView : UIView

@property(weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDevaultView;
@property(weak, nonatomic) IBOutlet UIButton *replyButton;

@property(weak, nonatomic) id<ILUserProfileWithReplyViewDelegate> delegate;

@property(strong, nonatomic) AVObject *commentObject;

- (IBAction)clickReplyButton:(id)sender;

@end
