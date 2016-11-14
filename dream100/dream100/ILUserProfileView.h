//
//  ILUserProfileView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ILUserProfileViewDelegate <NSObject>

- (void)selectUser:(id)sender;

@end

@interface ILUserProfileView : UIView

@property(weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *signInfoLabel;
@property(weak, nonatomic) IBOutlet UIButton *userButton;

@property(strong, nonatomic) AVUser *userObject;
@property(weak, nonatomic) id<ILUserProfileViewDelegate> delegate;

- (IBAction)clickUserButton:(id)sender;

@end
