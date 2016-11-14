//
//  ILJourneySectionHeaderCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILJourneySectionHeaderCell.h"

@implementation ILJourneySectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotJourneyButtonSelected {
    [_hotJourneyButton setSelected:YES];
    [_latestJourneyButton setSelected:NO];
    [_myJourneyButton setSelected:NO];
    [_joinedUserButton setSelected:NO];
}

- (void)setLatestJourneyButtonSelected {
    [_hotJourneyButton setSelected:NO];
    [_latestJourneyButton setSelected:YES];
    [_myJourneyButton setSelected:NO];
    [_joinedUserButton setSelected:NO];
}

- (void)setMyJourneyButtonSelected {
    [_hotJourneyButton setSelected:NO];
    [_latestJourneyButton setSelected:NO];
    [_myJourneyButton setSelected:YES];
    [_joinedUserButton setSelected:NO];
}

- (void)setJoinedUserButtonSelected {
    [_hotJourneyButton setSelected:NO];
    [_latestJourneyButton setSelected:NO];
    [_myJourneyButton setSelected:NO];
    [_joinedUserButton setSelected:YES];
}

- (IBAction)clickHotJourneyButton:(id)sender {
    [self setHotJourneyButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectHotJourney:)]) {
        [_delegate selectHotJourney:sender];
    }
}

- (IBAction)clickLatestJourneyButton:(id)sender {
    [self setLatestJourneyButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectLatestJourney:)]) {
        [_delegate selectLatestJourney:sender];
    }
}

- (IBAction)clickMyJourneyButton:(id)sender {
    [self setMyJourneyButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectMyJourney:)]) {
        [_delegate selectMyJourney:sender];
    }
}

- (IBAction)clickJoinedUserButton:(id)sender {
    [self setJoinedUserButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectJoinedUser:)]) {
        [_delegate selectJoinedUser:sender];
    }
}

@end
