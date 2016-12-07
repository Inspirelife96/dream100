//
//  ILJourneyCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILJourneyCell.h"
#import "CDUserManager.h"
#import "UILabel+StringFrame.h"
#import "HZPhotoItem.h"
#import "MyLikeCache.h"
#import "ILDreamDBManager.h"
#import <TTTTimeIntervalFormatter.h>

@implementation ILJourneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJourneyObject:(AVObject *)journeyObject {
    _journeyObject = journeyObject;
    
    _userProfileDefaultView.delegate = (id<ILUserProfileDefaultViewDelegate>)_delegate;
    _userProfileDefaultView.userObject = journeyObject[@"user"];
    
    _postContentView.contentString = journeyObject[@"content"];
    _postContentView.imageArray = journeyObject[@"imageFiles"];

    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:journeyObject[@"createdAt"]];
    
    NSInteger likeNumber = [_journeyObject[@"likeNumber"] integerValue];
    BOOL isLiked = [[MyLikeCache sharedInstance] isLiked:_journeyObject[@"objectId"]];
    [_likeButton setUserInteractionEnabled:YES];
    [_commentButton setUserInteractionEnabled:YES];
    if (isLiked) {
        [_likeButton setImage:[UIImage imageNamed:@"button_like_small"] forState:UIControlStateNormal];
        [_likeButton setTitle:[NSString stringWithFormat:@"%ld", (long)(likeNumber)]  forState:UIControlStateNormal];
    } else {
        [_likeButton setImage:[UIImage imageNamed:@"button_unlike_small"] forState:UIControlStateNormal];
        [_likeButton setTitle:[NSString stringWithFormat:@"%ld", (long)(likeNumber)]  forState:UIControlStateNormal];
    }
    
    NSInteger commentNumber = [_journeyObject[@"commentNumber"] integerValue];
    [_commentButton setImage:[UIImage imageNamed:@"button_comment_small"] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%ld", (commentNumber)]  forState:UIControlStateNormal];
    
}

+ (CGFloat)HeightForJourneyCell:(AVObject *)journeyObject {
    CGFloat contentHeight = [ILPostContentView HeightForContent:journeyObject[@"content"]];
    CGFloat imageHeight = [ILPostContentView HeightForImages:journeyObject[@"imageFiles"]];
    
    return 8.0f + 64.0 + contentHeight + imageHeight + 39.0f + 8.0f;
}


- (IBAction)clickLikeButton:(id)sender {
    [_likeButton setUserInteractionEnabled:NO];
    if ([_delegate respondsToSelector:@selector(likeJourney:)]) {
        [_delegate likeJourney:_journeyObject];
    }
}

- (IBAction)clickCommentButton:(id)sender {
    [_commentButton setUserInteractionEnabled:NO];
    if ([_delegate respondsToSelector:@selector(commentJourney:)]) {
        [_delegate commentJourney:_journeyObject];
    }
}


@end
