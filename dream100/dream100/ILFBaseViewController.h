//
//  ILFBaseViewController.h
//  dream100
//
//  Created by Chen XueFeng on 2016/11/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ILFViewControllerStyle) {
    ILFViewControllerStylePlain = 0,
    ILFViewControllerStylePresenting
};

@interface ILFBaseViewController : UIViewController

@property (nonatomic, assign) ILFViewControllerStyle viewControllerStyle;

- (void)showNetworkIndicator;

- (void)hideNetworkIndicator;

- (void)showProgress;

- (void)hideProgress;

- (void)showHUDText:(NSString *)text duration:(NSTimeInterval)duration;;

- (void)alert:(NSString *)msg;

- (BOOL)alertError:(NSError *)error;

- (BOOL)filterError:(NSError *)error;

- (void)runInMainQueue:(void (^)())queue;

- (void)runInGlobalQueue:(void (^)())queue;

- (void)runAfterSecs:(float)secs block:(void (^)())block;

@end
