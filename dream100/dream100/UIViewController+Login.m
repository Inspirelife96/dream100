//
//  UIViewController+Login.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/30.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+Login.h"
#import "CDLoginVC.h"
#import "CDBaseNavC.h"

@implementation UIViewController (Login)

- (BOOL)isLogin {
    if (![AVUser currentUser]) {
        CDLoginVC *loginVC = [[CDLoginVC alloc] init];
        CDBaseNavC *loginNav = [[CDBaseNavC alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNav animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

@end
