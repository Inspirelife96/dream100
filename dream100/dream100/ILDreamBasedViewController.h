//
//  ILDreamBasedViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/31.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILDreamBasedViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITableView *dreamTableView;
@property(strong, nonatomic) IBOutlet UIView *headerView;

@property(strong, nonatomic) NSMutableArray *dreamObjectArray;

- (void)refreshData;
- (void)fetchMoreData;
- (void)initTableViewDataAndRefresh;

@end
