//
//  ILJourneyCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILPostContentView.h"
#import "ILUserProfileDefaultView.h"

@protocol ILJourneyCellDelegate <NSObject>

- (void)likeJourney:(AVObject *)journeyObject;
- (void)commentJourney:(AVObject *)journeyObject;

@end

@interface ILJourneyCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDefaultView;
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
