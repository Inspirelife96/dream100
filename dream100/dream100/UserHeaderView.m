//
//  UserHeaderView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UserHeaderView.h"
#import "CDUserManager.h"

@implementation UserHeaderView

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
    
    [userObject getFollowersAndFollowees:^(NSDictionary *dict, NSError *error) {
        NSArray *followers = dict[@"followers"];
        NSArray *followees = dict[@"followees"];
        _followInfoLabel.text = [NSString stringWithFormat:@"关注:%ld | 粉丝:%ld", (long)followers.count, (long)followees.count];
    }];
    
    if ([userObject[@"objectId"] isEqualToString:[AVUser currentUser][@"objectId"]]) {
        [_followButton setHidden:YES];
        [_messageButton setHidden:YES];
    } else {
        [_followButton.layer setMasksToBounds:YES];
        [_followButton.layer setCornerRadius:10.0];
        _followButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_messageButton.layer setMasksToBounds:YES];
        [_messageButton.layer setCornerRadius:10.0];
        _messageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [[CDUserManager manager] isMyFriend:_userObject block:^(BOOL isFriend, NSError *error) {
            if(isFriend) {
                [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            } else {
                [_followButton setTitle:@"关注他" forState:UIControlStateNormal];
            }
        }];
    }
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
                    
                    [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }];
        }
    }];
    
    
    if([_delegate respondsToSelector:@selector(followOrUnfollow:)]) {
        [_delegate followOrUnfollow:sender];
    }
}

- (IBAction)clickMessageButton:(id)sender {
    if([_delegate respondsToSelector:@selector(sendMessage:)]) {
        [_delegate sendMessage:sender];
    }
}

@end
