//
//  UserInfoView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/8.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UserInfoView.h"
#import "CDUserManager.h"

@implementation UserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setUserObject:(AVUser *)userObject {
    if (userObject) {
        [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
            _profileImageView.image = image;
        }];
                
        _userNameLabel.text = userObject[@"username"];
    }
}

- (void)setCreatedAt:(NSDate *)createdAt {
    _timeLabel.text = [NSString stringWithFormat:@"%@", createdAt];
}

@end
