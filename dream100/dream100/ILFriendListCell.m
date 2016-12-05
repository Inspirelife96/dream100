//
//  ILFriendListCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFriendListCell.h"
#import "CDUserManager.h"
#import "ILDreamDBManager.h"

@implementation ILFriendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserObject:(AVUser *)userObject {
    _userObject = userObject;
    _userProfileDefualtView.userObject = userObject;
    _userProfileDefualtView.delegate = (id<ILUserProfileDefaultViewDelegate>)_delegate;
    
    [[CDUserManager manager] isMyFriend:userObject block:^(BOOL isFriend, NSError *error) {
        if(isFriend) {
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
        } else {
            [_followButton setTitle:@"关注他" forState:UIControlStateNormal];
        }
    }];
    
    [_messageButton setTitle:@"发私信" forState:UIControlStateNormal];
}

- (IBAction)clickFollowButton:(id)sender {
    [[CDUserManager manager] isMyFriend:_userObject block:^(BOOL isFriend, NSError *error) {
        if(isFriend) {
            [[CDUserManager manager] removeFriend:_userObject callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [_followButton setTitle:@"关注他" forState:UIControlStateNormal];
                }
            }];
        } else {
            [[CDUserManager manager] addFriend:_userObject callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    AVQuery *pushQuery = [AVInstallation query];
                    [pushQuery whereKey:@"owner" equalTo:_userObject];
                    NSString *alertMessage = [NSString stringWithFormat:@"%@关注了您", [AVUser currentUser].username];;
                    NSDictionary *data = @{
                                           @"alert": alertMessage,
                                           @"badge": @"Increment",
                                           @"followbadge": @"Increment",
                                           @"sound": @"cheering.caf",
                                           @"type": @"follow",
                                           @"dreamId": @"",
                                           @"journeyId": @"",
                                           };
                    
                    AVPush *push = [[AVPush alloc] init];
                    [push setQuery:pushQuery];
                    [push setData:data];
                    [push sendPushInBackground];
                    
                    [ILDreamDBManager updateBadge:3 forUser:_userObject];
                    
                    [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }];
        }
    }];
    
    if([_delegate respondsToSelector:@selector(clickFollow:)]) {
        [_delegate clickFollow:_userObject];
    }
}

- (IBAction)clickMessageButton:(id)sender {
    if([_delegate respondsToSelector:@selector(clickMessage:)]) {
        [_delegate clickMessage:_userObject];
    }
}

@end
