//
//  ILFollowMessageCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFollowMessageCell.h"
#import "CDUserManager.h"
#import <TTTTimeIntervalFormatter.h>

@implementation ILFollowMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserObject:(AVUser *)userObject {
    if (userObject) {
        [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
            _profileImageView.image = image;
        }];
        
        _userNameLabel.text = userObject[@"username"];
    }
}

- (void)setFollowDate:(NSDate *)followDate {
    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:followDate];
}

- (IBAction)clickUserButton:(id)sender {
    if([self.delegate respondsToSelector:@selector(clickUserProfile:)]) {
        [self.delegate clickUserProfile:sender];
    }
}

@end
