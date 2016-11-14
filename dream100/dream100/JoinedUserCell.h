//
//  JoinedUserCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/18.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinedUserCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *joinedTimeLabel;
@property(strong, nonatomic) IBOutlet UIImageView *statusImageView;

@property(strong, nonatomic) AVObject *dreamFollowObject;

@end
