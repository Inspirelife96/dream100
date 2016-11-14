//
//  LikedUserCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/18.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikedUserCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property(strong, nonatomic) AVObject *likedUserObject;

@end
