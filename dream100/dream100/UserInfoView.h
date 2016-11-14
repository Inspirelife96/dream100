//
//  UserInfoView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/8.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserInfoView : UIView

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;

@property(strong, nonatomic) AVUser *userObject;
@property(strong, nonatomic) NSDate *createdAt;

@end
