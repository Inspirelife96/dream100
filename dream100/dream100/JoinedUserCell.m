//
//  JoinedUserCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/18.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "JoinedUserCell.h"
#import "CDUserManager.h"

@implementation JoinedUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDreamFollowObject:(AVObject *)dreamFollowObject {
    _dreamFollowObject = dreamFollowObject;
    AVUser *user = dreamFollowObject[@"user"];
    _userNameLabel.text = user[@"username"];
    _joinedTimeLabel.text = [NSString stringWithFormat:@"%@许下这个个梦想", dreamFollowObject[@"createdAt"]];
    [[CDUserManager manager] getAvatarImageOfUser:user block:^(UIImage *image) {
        _profileImageView.image = image;
    }];
    
    if ([dreamFollowObject[@"status"] isEqualToString:@"如愿"]) {
        _statusImageView.image = [UIImage imageNamed:@"button_done"];
    } else if ([dreamFollowObject[@"status"] isEqualToString:@"追梦"]) {
        _statusImageView.image = [UIImage imageNamed:@"button_progress"];
    } else {
        _statusImageView.image = [UIImage imageNamed:@"button_join"];
    }
}

@end
