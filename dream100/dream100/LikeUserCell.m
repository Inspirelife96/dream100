//
//  LikeUserCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "LikeUserCell.h"
#import "CDUserManager.h"

@implementation LikeUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserCountObject:(AVObject *)userCountObject {
    _userCountObject = userCountObject;
    AVUser *user = userCountObject[@"user"];
    _userNameLabel.text = user[@"username"];
    _countLabel.text = [NSString stringWithFormat:@"共许下%ld个梦想", (long)[userCountObject[@"dreamCount"] integerValue]];
    [[CDUserManager manager] getAvatarImageOfUser:user block:^(UIImage *image) {
        _profileImageView.image = image;
    }];
}

@end
