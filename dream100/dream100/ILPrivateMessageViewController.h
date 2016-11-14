//
//  ILPrivateMessageViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/3.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILCommentBaseViewController.h"

@interface ILPrivateMessageViewController : ILCommentBaseViewController

@property(weak, nonatomic) IBOutlet UITableView *messageTableView;

@property(strong, nonatomic) AVUser *userObject;

@end
