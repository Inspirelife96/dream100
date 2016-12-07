//
//  ILMessageDefaultCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILMessageDefaultCell.h"
#import <TTTTimeIntervalFormatter.h>

@implementation ILMessageDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMessageObject:(AVObject *)messageObject {
    _messageObject = messageObject;
    AVUser *userObject = nil;
    NSString *fromUserId = messageObject[@"fromUser"][@"objectId"];
    
    if ([fromUserId isEqualToString:[AVUser currentUser].objectId]) {
        userObject = messageObject[@"toUser"];
    } else {
        userObject = messageObject[@"fromUser"];
    }
    
    _userProfileDevaultView.userObject = userObject;
    _userProfileDevaultView.delegate = _delegate;
    _userProfileDevaultView.mottoLabel.text = messageObject[@"message"];
    
    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:messageObject[@"updatedAt"]];
}

@end
