//
//  ILJourneyViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILCommentBaseViewController.h"
#import "ILDreamModel.h"
#import "ILDreamCell.h"

@interface ILJourneyViewController : ILCommentBaseViewController

@property(weak, nonatomic) IBOutlet UITableView *journeyTableView;
@property(weak, nonatomic) IBOutlet UIView *journeyHeaderView;

@property(strong, nonatomic) AVObject *dreamObject;

@end
