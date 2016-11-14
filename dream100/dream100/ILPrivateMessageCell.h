//
//  ILPrivateMessageCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILPrivateMessageCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property(weak, nonatomic) IBOutlet UIButton *userButton;
@property(weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *messageWidthConstraint;

@property(strong, nonatomic) AVObject *messageObject;

+ (CGFloat)HeightForCell:(NSString *)contentString;

@end
