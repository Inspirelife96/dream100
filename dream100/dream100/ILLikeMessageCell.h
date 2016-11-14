//
//  ILLikeMessageCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/10.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDelegate.h"

@interface ILLikeMessageCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *likeInfoLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *likeInfoHeight;

@property(weak, nonatomic) id<ILCommentMessageCellDelegate> delegate;

@property(strong, nonatomic) AVObject *likeObject;

+ (CGFloat)calculateLikeMessageCellHeight:(AVObject *)likeObject;

@end
