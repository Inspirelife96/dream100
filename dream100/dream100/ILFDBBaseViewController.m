//
//  ILFDBBaseViewController.m
//  dream100
//
//  Created by Chen XueFeng on 2016/11/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILFDBBaseViewController.h"

@interface ILFDBBaseViewController ()

@end

@implementation ILFDBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamDBOperationError:) name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dreamUIUpdate:) name:@"ILDreamUIUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyLikeUpdate:) name:@"ILJourneyLikeUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journeyCommentUpdate:) name:@"ILJourneyCommentUpdateNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILDreamDBOperationErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILDreamUIUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILJourneyLikeUpdateNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ILJourneyCommentUpdateNotification" object:nil];
}

- (void)dreamDBOperationError:(id)notification {
    [self hideProgress];
    NSArray *notificationArray = [notification object];
    if (notificationArray.count > 0) {
        NSError *error = notificationArray[0];
        [self alertError:error];
    } else {
        [self alert:@"未知错误，请稍后再尝试！"];
    }
}

- (void)dreamUIUpdate:(id)notification {
    // do nothing, overwrite in sub class
}

- (void)journeyLikeUpdate:(id)notification {
    // do nothing, overwrite in sub class
}

- (void)journeyCommentUpdate:(id)notification {
    // do nothing, overwrite in sub class
}

@end
