//
//  ILCommentMessageCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDelegate.h"
#import "ILUserProfileWithReplyView.h"

@interface ILCommentMessageCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileWithReplyView *userProfileWithReplayView;
@property(weak, nonatomic) IBOutlet UILabel *commentInfoLabel;
@property(weak, nonatomic) IBOutlet UILabel *commentDetailLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *commentInfoHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *commentDetailHeight;

@property(weak, nonatomic) id<ILCommentMessageCellDelegate> delegate;

@property(strong, nonatomic) AVObject *commentObject;

+ (CGFloat)calculateCommentMessageCellHeight:(AVObject *)commentObject;

@end
