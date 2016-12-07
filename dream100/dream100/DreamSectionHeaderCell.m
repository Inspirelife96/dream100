//
//  ILDiscoverySectionHeaderCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/6.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDiscoverySectionHeaderCell.h"

@implementation ILDiscoverySectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotButtonSelected {
    [_hotButton setSelected:YES];
    [_latestButton setSelected:NO];
    [_followButton setSelected:NO];
}

- (void)setLatestButtonSelected {
    [_hotButton setSelected:NO];
    [_latestButton setSelected:YES];
    [_followButton setSelected:NO];
}
- (void)setfollowButtonSelected {
    [_hotButton setSelected:NO];
    [_latestButton setSelected:NO];
    [_followButton setSelected:YES];
}

- (IBAction)clickHotButton:(id)sender {
    [self setHotButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectHotButton:)]) {
        [_delegate selectHotButton:sender];
    }
}

- (IBAction)clickLatestButton:(id)sender {
    [self setLatestButtonSelected];
    if ([_delegate respondsToSelector:@selector(selectLatestButton:)]) {
        [_delegate selectLatestButton:sender];
    }
}

- (IBAction)clickFollowButton:(id)sender {
    [self setfollowButtonSelected];
    if ([_delegate respondsToSelector:@selector(selectFollowButton:)]) {
        [_delegate selectFollowButton:sender];
    }
}

@end
