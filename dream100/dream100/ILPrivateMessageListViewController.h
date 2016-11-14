//
//  ILPrivateMessageListViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILPrivateMessageListViewController : UIViewController

@property(weak, nonatomic) IBOutlet UITableView *messageTableView;

@property(strong, nonatomic) AVUser *userObject;

@end
