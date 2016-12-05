//
//  ILFBaseViewController.m
//  dream100
//
//  Created by Chen XueFeng on 2016/11/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SGActionView.h"

@interface ILFBaseViewController ()

@end

@implementation ILFBaseViewController

#pragma mark Life Circle
- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.viewControllerStyle = ILFViewControllerStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.viewControllerStyle == ILFViewControllerStylePresenting) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissViewController:)];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [AVAnalytics beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [AVAnalytics endLogPageView:NSStringFromClass([self class])];
}

- (void)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utilities
- (void)alert:(NSString*)msg {
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //
//    }];
//    [alertVC addAction:okAction];
//    
//    [self presentViewController:alertVC animated:YES completion:nil];
    
    [SGActionView showAlertWithTitle:@"" message:msg buttonTitle:@"确认" selectedHandle:^(NSInteger index) {
        //
    }];
}

- (BOOL)alertError:(NSError *)error {
    if (error) {
        [AVAnalytics event:@"Alert Error" attributes:@{@"desc": error.description}];
    }
    
    if (error) {
        if ([error.domain isEqualToString:NSURLErrorDomain]) {
            [self alert:@"网络连接发生错误"];
        }
        else {
            NSString *info = error.localizedDescription;
            [self alert:info ? info : [NSString stringWithFormat:@"%@", error]];
        }
        return YES;
    }
    return NO;
}

- (BOOL)filterError:(NSError *)error {
    return [self alertError:error] == NO;
}

-(void)showNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

-(void)hideNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showHUDText:(NSString *)text duration:(NSTimeInterval)duration {
    [AVAnalytics event:@"HUDText" attributes:@{@"text": text}];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:duration];
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

@end
