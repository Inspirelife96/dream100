//
//  ILUserProfileView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILUserProfileView.h"
#import "CDUserManager.h"

@implementation ILUserProfileView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUserObject:(AVUser *)userObject {
    _userObject = userObject;
    
    [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
        _profileImageView.image = image;
    }];
    
    _userNameLabel.text = userObject[@"username"];
    _signInfoLabel.text = userObject[@"signInfo"];
}

- (IBAction)clickUserButton:(id)sender {
    if([_delegate respondsToSelector:@selector(selectUser:)]) {
        [_delegate selectUser:sender];
    }
}
@end
