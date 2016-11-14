//
//  ILUserProfileDefaultView.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILUserProfileDefaultView.h"
#import "CDUserManager.h"

@implementation ILUserProfileDefaultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUserObject:(AVUser *)userObject {
    _userObject = userObject;
    
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius = 22.0f;
    _profileImageView.layer.borderWidth = 3.0f;
    _profileImageView.layer.borderColor = FlatLime.CGColor;
    
    if (userObject) {
        [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
            _profileImageView.image = image;
        }];
        
        _nameLabel.text = userObject[@"username"];
        if (userObject[@"motto"]) {
            _mottoLabel.text = userObject[@"motto"];
        } else {
            _mottoLabel.text = @"去实现梦想，不管结果如何，努力过才不会后悔。";
        }
    } else {
        _profileImageView.image = [UIImage imageNamed:@""];
        _nameLabel.text = @"未登录";
        _mottoLabel.text = @"快来登陆并管理实现您的梦想吧！";
    }
}

- (IBAction)clickProfileButton:(id)sender {
    if(_userObject && [self.delegate respondsToSelector:@selector(clickProfile:)]) {
        [self.delegate clickProfile:_userObject];
    }
}

@end
