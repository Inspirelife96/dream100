//
//  UserProfileCell.h
//  learnpaint
//
//  Created by Chen XueFeng on 16/8/20.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDefaultView.h"

@interface UserProfileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDefaultView;

@property(weak, nonatomic) id<ILUserProfileDefaultViewDelegate> delegate;

@property(strong, nonatomic) AVUser *userObject;

@end
