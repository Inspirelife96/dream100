//
//  LikeUserCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeUserCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *countLabel;

@property(strong, nonatomic) AVObject *userCountObject;

@end
