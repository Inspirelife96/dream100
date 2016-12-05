//
//  ILLikeMessageCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/10.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILLikeMessageCell.h"
#import "UILabel+StringFrame.h"
#import <UILabel+YBAttributeTextTapAction.h>
#import <TTTTimeIntervalFormatter.h>

@implementation ILLikeMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLikeObject:(AVObject *)likeObject {
    _likeObject = likeObject;
    _likeInfoLabel.attributedText = [self prepareLikeInfo];
    
    NSString *dreamString = [ILLikeMessageCell prepareDreamString:likeObject];
    NSString *journeyString = [ILLikeMessageCell prepareJourneyString:likeObject];
    NSString *userString = likeObject[@"fromUser"][@"username"];
    
    [_likeInfoLabel yb_addAttributeTapActionWithStrings:@[userString, journeyString, dreamString] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        //
        if ([string isEqualToString:userString]) {
            if([self.delegate respondsToSelector:@selector(clickUser:)]) {
                [self.delegate clickUser:_likeObject[@"fromUser"]];
            }
        } else if ([string isEqualToString:journeyString]) {
            if([self.delegate respondsToSelector:@selector(clickJourney:)]) {
                [self.delegate clickJourney:_likeObject[@"journey"]];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(clickDream:)]) {
                [self.delegate clickDream:_likeObject[@"journey"][@"dream"]];
            }
        }
    }];
    
    _likeInfoHeight.constant = [ILLikeMessageCell calculateInfoHeight:likeObject] + 16.0f;
    
    TTTTimeIntervalFormatter *timeFormater = [[TTTTimeIntervalFormatter alloc] init];
    _timeLabel.text = [timeFormater stringForTimeIntervalFromDate:[NSDate date] toDate:likeObject[@"createdAt"]];
}

+ (CGFloat)calculateInfoHeight:(AVObject *)likeObject {
    NSString *dreamString = [ILLikeMessageCell prepareDreamString:likeObject];
    NSString *journeyString = [ILLikeMessageCell prepareJourneyString:likeObject];
    NSString *userString = likeObject[@"fromUser"][@"username"];
    NSString *likeInfoString = [NSString stringWithFormat:@"❤️ %@ 喜欢了您的心路历程《%@》－ 为了实现梦想《%@》而努力", userString, journeyString, dreamString];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = likeInfoString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20.0f, 0.0f) attributes:nil];
    return size.height;
}

+ (NSString *)prepareJourneyString:(AVObject *)likeObject {
    AVObject *journeyObject = likeObject[@"journey"];
    NSString *journeyString = journeyObject[@"content"];
    if (journeyString.length > 10) {
        journeyString = [NSString stringWithFormat:@"%@...", [journeyString substringToIndex:10]];
    }
    
    return journeyString;
}

+ (NSString *)prepareDreamString:(AVObject *)likeObject {
    AVObject *dreamObject = likeObject[@"journey"][@"dream"];
    NSString *dreamString = dreamObject[@"content"];
    if (dreamString.length > 10) {
        dreamString = [NSString stringWithFormat:@"%@...", [dreamString substringToIndex:10]];
    }
    
    return dreamString;
}

- (NSMutableAttributedString *)prepareLikeInfo {
    NSString *dreamString = [ILLikeMessageCell prepareDreamString:_likeObject];
    NSString *journeyString = [ILLikeMessageCell prepareJourneyString:_likeObject];
    NSString *userString = _likeObject[@"fromUser"][@"username"];
    NSString *likeInfoString = [NSString stringWithFormat:@"❤️ %@ 喜欢了您的心路历程《%@》－ 为了实现梦想《%@》而努力", userString, journeyString, dreamString];
    NSRange userRange = [likeInfoString rangeOfString:userString];
    NSRange dreamRange = [likeInfoString rangeOfString:dreamString];
    NSRange journeyRange = [likeInfoString rangeOfString:journeyString];
    
    NSMutableAttributedString *attributedInfoString = [[NSMutableAttributedString alloc]initWithString:likeInfoString];
    
    [attributedInfoString addAttribute:NSFontAttributeName value:GetFontAvenirNext(14.0) range:NSMakeRange(0, likeInfoString.length)];
    [attributedInfoString addAttribute:NSForegroundColorAttributeName value:FlatBlue range:userRange];
    [attributedInfoString addAttribute:NSForegroundColorAttributeName value:FlatBlue range:dreamRange];
    [attributedInfoString addAttribute:NSForegroundColorAttributeName value:FlatBlue range:journeyRange];
    
    return attributedInfoString;
}

+ (CGFloat)calculateLikeMessageCellHeight:(AVObject *)likeObject {
    CGFloat infoHeight = [ILLikeMessageCell calculateInfoHeight:likeObject];
    return infoHeight + 16.0f + 8.0 + 21.0f + 8.0f;
}

@end
