//
//  UserHeaderView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeaderViewDelegate <NSObject>

- (void)followOrUnfollow:(id)sender;
- (void)sendMessage:(id)sender;
- (void)filter:(NSInteger)dreamCategory;

@end


@interface UserHeaderView : UIView

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *followInfoLabel;
@property(strong, nonatomic) IBOutlet UIButton *followButton;
@property(strong, nonatomic) IBOutlet UIButton *messageButton;

@property (nonatomic, weak) id<UserHeaderViewDelegate> delegate;


- (IBAction)clickFollowButton:(id)sender;
- (IBAction)clickMessageButton:(id)sender;

@property(strong, nonatomic) AVUser *userObject;

@end
