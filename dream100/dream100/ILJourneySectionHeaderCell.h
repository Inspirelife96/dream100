//
//  ILJourneySectionHeaderCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ILJourneySectionHeaderCellDelegate <NSObject>

- (void)selectHotJourney:(id)sender;
- (void)selectLatestJourney:(id)sender;
- (void)selectMyJourney:(id)sender;
- (void)selectJoinedUser:(id)sender;

@end

@interface ILJourneySectionHeaderCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIButton *hotJourneyButton;
@property(strong, nonatomic) IBOutlet UIButton *latestJourneyButton;
@property(strong, nonatomic) IBOutlet UIButton *myJourneyButton;
@property(strong, nonatomic) IBOutlet UIButton *joinedUserButton;

@property (nonatomic, weak) id<ILJourneySectionHeaderCellDelegate> delegate;

- (void)setHotJourneyButtonSelected;
- (void)setLatestJourneyButtonSelected;
- (void)setMyJourneyButtonSelected;
- (void)setJoinedUserButtonSelected;

- (IBAction)clickHotJourneyButton:(id)sender;
- (IBAction)clickLatestJourneyButton:(id)sender;
- (IBAction)clickMyJourneyButton:(id)sender;
- (IBAction)clickJoinedUserButton:(id)sender;

@end
