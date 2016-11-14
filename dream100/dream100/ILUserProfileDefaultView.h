//
//  ILUserProfileDefaultView.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDelegate.h"

@interface ILUserProfileDefaultView : UIView

@property(weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UIButton *profileButton;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *mottoLabel;

@property(weak, nonatomic) id<ILUserProfileDefaultViewDelegate> delegate;

@property(strong, nonatomic) AVUser *userObject;

- (IBAction)clickProfileButton:(id)sender;

@end
