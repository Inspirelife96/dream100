//
//  UIViewController+DreamAction.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/27.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DreamAction)

- (void)showActionForDream:(AVObject *)dreamObject onView:(UIView *)sender;
- (void)tipoffs:(UIView *)sender forObject:(AVObject *)object;

@end
