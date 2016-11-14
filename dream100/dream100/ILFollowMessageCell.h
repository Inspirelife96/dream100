//
//  ILFollowMessageCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDelegate.h"


@interface ILFollowMessageCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UIButton *userButton;

@property(weak, nonatomic) id<ILUserProfileDelegate> delegate;

@property(strong, nonatomic) AVUser *userObject;
@property(strong, nonatomic) NSDate *followDate;

- (IBAction)clickUserButton:(id)sender;

@end
