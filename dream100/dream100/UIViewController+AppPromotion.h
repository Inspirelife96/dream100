//
//  UIViewController+AppPromotion.h
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AppPromotion)

- (void)promotion;
- (void)promotionApp:(NSNumber *)appId;
- (NSNumber *)getPromationAppInfo;

@end
