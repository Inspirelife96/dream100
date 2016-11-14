//
//  CommentCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) IBOutlet UILabel *journeyContentLabel;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property(strong, nonatomic) AVObject *commentObject;

+ (CGFloat)HeightForCommentCell:(AVObject *)commentObject;

@end
