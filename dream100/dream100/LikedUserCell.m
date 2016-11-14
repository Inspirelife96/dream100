//
//  LikedUserCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/18.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "LikedUserCell.h"
#import "CDUserManager.h"

@implementation LikedUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLikedUserObject:(AVObject *)likedUserObject {
    _likedUserObject = likedUserObject;
    AVUser *user = likedUserObject[@"user"];
    _userNameLabel.text = user[@"username"];
    [[CDUserManager manager] getAvatarImageOfUser:user block:^(UIImage *image) {
        _profileImageView.image = image;
    }];
}

@end
