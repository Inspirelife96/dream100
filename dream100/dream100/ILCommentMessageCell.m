//
//  ILCommentMessageCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILCommentMessageCell.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "UILabel+StringFrame.h"
#import <TTTTimeIntervalFormatter.h>

@implementation ILCommentMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentObject:(AVObject *)commentObject {
    _commentObject = commentObject;
    _userProfileWithReplayView.delegate = (id<ILUserProfileWithReplyViewDelegate>)self.delegate;
    _userProfileWithReplayView.commentObject = commentObject;
    NSString *dreamString = [ILCommentMessageCell prepareDreamString:commentObject];
    NSString *journeyString = [ILCommentMessageCell prepareJourneyString:commentObject];
    _commentInfoLabel.attributedText = [self prepareCommentInfo];
    
    [_commentInfoLabel yb_addAttributeTapActionWithStrings:@[dreamString,journeyString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        //
        if ([string isEqualToString:dreamString]) {
            if([self.delegate respondsToSelector:@selector(clickDream:)]) {
                [self.delegate clickDream:self.commentObject[@"journey"][@"dream"]];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(clickJourney:)]) {
                [self.delegate clickJourney:self.commentObject[@"journey"]];
            }
        }
    }];
    
    _commentDetailLabel.text = commentObject[@"comment"];
    _commentDetailLabel.font = GetFontAvenirNext(14.0f);
    
    _commentInfoHeight.constant = [ILCommentMessageCell calculateInfoHeight:commentObject] + 16.0f;
    _commentDetailHeight.constant = [ILCommentMessageCell calculateDetailHeight:commentObject] + 48.0f;
    
    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:commentObject[@"createdAt"]];
}

+ (CGFloat)calculateInfoHeight:(AVObject *)commentObject {
    NSString *dreamString = [ILCommentMessageCell prepareDreamString:commentObject];
    NSString *journeyString = [ILCommentMessageCell prepareJourneyString:commentObject];
    
    NSString *commentInfoString = [NSString stringWithFormat:@"您在梦想《%@》的心路历程《%@》中收到一条新的评论", dreamString, journeyString];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = commentInfoString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20.0f, 0.0f) attributes:nil];
    return size.height;
}

+ (CGFloat)calculateDetailHeight:(AVObject *)commentObject {
    UILabel *label = [[UILabel alloc] init];
    
    label.text = commentObject[@"comment"];
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    return size.height;
}

+ (NSString *)prepareJourneyString:(AVObject *)commentObject {
    AVObject *journeyObject = commentObject[@"journey"];
    NSString *journeyString = journeyObject[@"content"];
    if (journeyString.length > 10) {
        journeyString = [NSString stringWithFormat:@"%@...", [journeyString substringToIndex:10]];
    }
    
    return journeyString;
}

+ (NSString *)prepareDreamString:(AVObject *)commentObject {
    AVObject *dreamObject = commentObject[@"journey"][@"dream"];
    NSString *dreamString = dreamObject[@"content"];
    if (dreamString.length > 10) {
        dreamString = [NSString stringWithFormat:@"%@...", [dreamString substringToIndex:10]];
    }
    
    return dreamString;
}

- (NSMutableAttributedString *)prepareCommentInfo {
    NSString *dreamString = [ILCommentMessageCell prepareDreamString:self.commentObject];
    NSString *journeyString = [ILCommentMessageCell prepareJourneyString:self.commentObject];
    
    NSString *commentInfoString = [NSString stringWithFormat:@"您在梦想《%@》的心路历程《%@》中收到一条新的评论", dreamString, journeyString];
    NSRange dreamRange = [commentInfoString rangeOfString:dreamString];
    NSRange journeyRange = [commentInfoString rangeOfString:journeyString];
    
    
    NSMutableAttributedString *attributedInfoString = [[NSMutableAttributedString alloc]initWithString:commentInfoString];
    
    [attributedInfoString addAttribute:NSFontAttributeName value:GetFontAvenirNext(14.0) range:NSMakeRange(0, commentInfoString.length)];
    [attributedInfoString addAttribute:NSForegroundColorAttributeName value:FlatBlue range:dreamRange];
    [attributedInfoString addAttribute:NSForegroundColorAttributeName value:FlatBlue range:journeyRange];
    
    return attributedInfoString;
}

+ (CGFloat)calculateCommentMessageCellHeight:(AVObject *)commentObject {
    CGFloat infoHeight = [ILCommentMessageCell calculateInfoHeight:commentObject];
    CGFloat detailHeight = [ILCommentMessageCell calculateDetailHeight:commentObject];
    return 64.0f + infoHeight + 16.0f + detailHeight + 48.0f + 21.0f + 8.0f;
}

@end
