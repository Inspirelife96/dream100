//
//  ILMessageDefaultCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDelegate.h"
#import "ILUserProfileDefaultView.h"

@interface ILMessageDefaultCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDevaultView;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(weak, nonatomic) id<ILUserProfileDefaultViewDelegate> delegate;

@property(strong, nonatomic) AVObject *messageObject;

@end
