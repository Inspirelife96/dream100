//
//  ILCommentViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JourneyContentView.h"
#import "ILCommentBaseViewController.h"


@interface ILCommentViewController : ILCommentBaseViewController

@property(strong, nonatomic) IBOutlet UITableView *commentTableView;
@property(strong, nonatomic) IBOutlet UIView *commentyHeaderView;

@property(strong, nonatomic) AVObject *journeyObject;

@end
