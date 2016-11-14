//
//  ILJourneyCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILPostContentView.h"
#import "ILUserProfileView.h"

@protocol ILJourneyCellDelegate <NSObject>

- (void)selectLike:(id)sender;
- (void)selectComment:(id)sender;

@end

@interface ILJourneyCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileView *userProfileView;
@property(weak, nonatomic) IBOutlet ILPostContentView *postContentView;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UIButton *likeButton;
@property(weak, nonatomic) IBOutlet UIButton *commentButton;

@property(strong, nonatomic) AVObject *journeyObject;
@property(weak, nonatomic) id<ILJourneyCellDelegate> delegate;

+ (CGFloat)HeightForJourneyCell:(AVObject *)journeyObject;

- (IBAction)clickLikeButton:(id)sender;
- (IBAction)clickCommentButton:(id)sender;

@end
