//
//  ILFriendListViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ILFriendType) {
    ILFriendTypeFollower,
    ILFriendTypeFollowee,
    ILFriendTypeBlocked,
};

@interface ILFriendListViewController : UIViewController

@property(weak, nonatomic) IBOutlet UITableView *friendTableView;

@property(assign, nonatomic) ILFriendType friendType;

@end
