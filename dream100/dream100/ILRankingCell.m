//
//  ILRankingCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/11.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILRankingCell.h"

@implementation ILRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCountObject:(AVObject *)countObject {
    _countObject = countObject;
    _userProfileDevaultView.userObject = countObject[@"user"];
    _userProfileDevaultView.delegate = _delegate;
    NSInteger count = 0;
    switch (_rankType) {
        case ILRankTypeDream:
            count = [countObject[@"dreamCount"] integerValue];
            _countLabel.text = [NSString stringWithFormat:@"怀揣了%ld个梦想", (long)count];
            break;
        case ILRankTypeJourney:
            count = [countObject[@"journeyCount"] integerValue];
            _countLabel.text = [NSString stringWithFormat:@"经历了%ld个实践", (long)count];
            break;
        case ILRankTypeComment:
            count = [countObject[@"commentCount"] integerValue];
            _countLabel.text = [NSString stringWithFormat:@"添加了%ld个评论", (long)count];
            break;
        case ILRankTypeLike:
            count = [countObject[@"likeCount"] integerValue];
            _countLabel.text = [NSString stringWithFormat:@"送出了%ld个喜欢", (long)count];
            break;
    }
}

- (void)setRankType:(ILRankType)rankType {
    _rankType = rankType;
}

@end
