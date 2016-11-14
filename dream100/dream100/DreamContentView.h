//
//  DreamContentView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/8.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZPhotoGroup;

@interface DreamContentView : UIView

@property(strong, nonatomic) IBOutlet UIButton *categoryButton;
@property(strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property(strong, nonatomic) IBOutlet UILabel *contentLabel;
@property(strong, nonatomic) IBOutlet HZPhotoGroup *photoGroup;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property(strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeightConstraint;

@property(strong, nonatomic) AVObject *dreamObject;

+ (CGFloat)HeightForDreamContentView:(AVObject *)dreamObject;

@end
