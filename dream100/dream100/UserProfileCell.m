//
//  UserProfileCell.m
//  learnpaint
//
//  Created by Chen XueFeng on 16/8/20.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UserProfileCell.h"

@implementation UserProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserObject:(AVUser *)userObject {
    _userProfileDefaultView.delegate = _delegate;
    _userProfileDefaultView.userObject = userObject;
}

@end
