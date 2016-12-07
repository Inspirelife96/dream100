//
//  DreamCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/5.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZPhotoGroup.h"
#import "ILDreamModel.h"

@protocol DreamCellDelegate <NSObject>

- (void)joinDream:(id)sender;

@end

@interface DreamCell : UITableViewCell

//@property(strong, nonatomic) IBOutlet UIImageView *profileImageView;
//@property(strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(strong, nonatomic) IBOutlet UILabel *timeLabel;
@property(strong, nonatomic) IBOutlet UILabel *contentLabel;
@property(strong, nonatomic) IBOutlet HZPhotoGroup *photoGroup;
@property(strong, nonatomic) IBOutlet UIButton *shareButton;
@property(strong, nonatomic) IBOutlet UIButton *categoryButton;
@property(strong, nonatomic) IBOutlet UIButton *addToMyDreamButton;
@property(strong, nonatomic) IBOutlet UILabel *dreamStatusLabel;

@property(strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property(strong, nonatomic) IBOutlet NSLayoutConstraint *photoHeightConstraint;

@property(strong, nonatomic) AVObject *dreamObject;

@property(weak, nonatomic) id<DreamCellDelegate> delegate;

- (IBAction)clickAddToMyDreamButton:(id)sender;

+ (CGFloat)HeightForDreamCell:(AVObject *)dreamObject;

@end
