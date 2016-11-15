//
//  CommentCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDefaultView.h"

@protocol CommentCellDelegate <NSObject>

- (void)replyComment:(AVObject *)commentObject;

@end

@interface CommentCell : UITableViewCell

@property(strong, nonatomic) IBOutlet ILUserProfileDefaultView *userprofielDefaultView;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) IBOutlet UILabel *commentLabel;
@property(strong, nonatomic) IBOutlet UIButton *replyButton;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *commentHeightConstraint;

@property(strong, nonatomic) AVObject *commentObject;
@property(weak, nonatomic) id<CommentCellDelegate> delegate;

+ (CGFloat)HeightForCommentCell:(AVObject *)commentObject;

- (IBAction)clickReplyButton:(id)sender;

@end
