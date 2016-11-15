//
//  UIViewController+AlertError.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/31.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+AlertError.h"
#import "SGActionView.h"

@implementation UIViewController (AlertError)

- (void)alertError:(NSError *)error {
    [SGActionView showAlertWithTitle:@"操作失败3" message:@"貌似您的网络有问题，请确认后再次尝试。" buttonTitle:@"确认" selectedHandle:^(NSInteger index) {
        //
    }];
}

@end
