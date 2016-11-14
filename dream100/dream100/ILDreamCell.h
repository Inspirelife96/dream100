//
//  ILDreamCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "ILPostContentView.h"

@protocol ILDreamCellDelegate <NSObject>

- (void)selectAction:(id)sender;

@end

@interface ILDreamCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIView *borderView;
@property(strong, nonatomic) IBOutlet UIButton *categoryButton;
@property(strong, nonatomic) IBOutlet UIButton *actionButton;
@property(strong, nonatomic) IBOutlet ILPostContentView *postContentView;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) IBOutlet UILabel *dreamStatusLabel;

@property(strong, nonatomic) AVObject *dreamObject;
@property(weak, nonatomic) id<ILDreamCellDelegate> delegate;

- (IBAction)clickActionButton:(id)sender;

+ (CGFloat)HeightForDreamCell:(AVObject *)dreamObject;

@end
