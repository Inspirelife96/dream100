//
//  CommentCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "CommentCell.h"
#import "CDUserManager.h"
#import "UILabel+StringFrame.h"
#import <TTTTimeIntervalFormatter.h>

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentObject:(AVObject *)commentObject {
    _commentObject = commentObject;
    AVUser *fromUser = commentObject[@"fromUser"];
    _userprofielDefaultView.delegate = (id<ILUserProfileDefaultViewDelegate>)_delegate;
    _userprofielDefaultView.userObject = fromUser;
    
    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:commentObject[@"createdAt"]];
    
    _commentLabel.text = commentObject[@"comment"];
    _commentLabel.font = GetFontAvenirNext(14.0f);
    _commentLabel.textColor = FlatBlue;
    CGSize size = [_commentLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    _commentHeightConstraint.constant = size.height + 16.0f + 8.0f;
    
    
    if ([fromUser.objectId isEqualToString:[AVUser currentUser].objectId]) {
        [_replyButton setHidden:YES];
    } else {
        [_replyButton setHidden:NO];
    }
    
}

+ (CGFloat)HeightForCommentCell:(AVObject *)commentObject {
    NSString *contentString = commentObject[@"comment"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = contentString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    
    return 8.0f + 64.0 + size.height + 24.0f + 37.0f + 8.0f;
}

- (IBAction)clickReplyButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(replyComment:)]) {
        [_delegate replyComment:_commentObject];
    }
}

@end
