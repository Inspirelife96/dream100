//
//  ILFriendListCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDefaultView.h"

@protocol ILFriendListCellDelegate <NSObject>

- (void)clickFollow:(AVUser *)userObject;
- (void)clickMessage:(AVUser *)userObject;

@end

@interface ILFriendListCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDefualtView;
@property(weak, nonatomic) IBOutlet UIButton *followButton;
@property(weak, nonatomic) IBOutlet UIButton *messageButton;

@property(weak, nonatomic) id<ILFriendListCellDelegate> delegate;

@property(strong, nonatomic) AVUser *userObject;

- (IBAction)clickFollowButton:(id)sender;
- (IBAction)clickMessageButton:(id)sender;

@end
