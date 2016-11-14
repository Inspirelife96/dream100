//
//  JourneyContentView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoGroup.h"

@interface JourneyContentView : UIView

@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) IBOutlet UILabel *journeyContentLabel;
@property(strong, nonatomic) IBOutlet HZPhotoGroup *journeyPhotoGroup;
@property(strong, nonatomic) IBOutlet UIButton *likeButton;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property(strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeightConstraint;

@property(strong, nonatomic) AVObject *journeyObject;

- (IBAction)clickLikeButton:(id)sender;

+ (CGFloat)HeightForJourneyContentView:(AVObject *)journeyObject;

@end
