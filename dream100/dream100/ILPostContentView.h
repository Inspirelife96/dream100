//
//  ILPostContentView.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoGroup.h"

@interface ILPostContentView : UIView

@property(strong, nonatomic) IBOutlet UILabel *contentLabel;
@property(strong, nonatomic) IBOutlet HZPhotoGroup *photoGroup;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property(strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeightConstraint;

@property(strong, nonatomic) NSString *contentString;
@property(strong, nonatomic) NSArray *imageArray;

+ (CGFloat)HeightForContent:(NSString *)contentString;
+ (CGFloat)HeightForImages:(NSArray *)imageArray;

@end
