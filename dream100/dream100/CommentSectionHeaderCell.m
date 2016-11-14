//
//  CommentSectionHeaderCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "CommentSectionHeaderCell.h"

@implementation CommentSectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentButtonSelected {
    [_commentButton setSelected:YES];
    [_likeButton setSelected:NO];
}

- (void)setLikeButtonSelected {
    [_commentButton setSelected:NO];
    [_likeButton setSelected:YES];
}

- (IBAction)clickCommentButton:(id)sender {
    [self setCommentButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectCommentSection:)]) {
        [_delegate selectCommentSection:sender];
    }
}

- (IBAction)clickLikeButton:(id)sender {
    [self setLikeButtonSelected];
    
    if ([_delegate respondsToSelector:@selector(selectLikeSection:)]) {
        [_delegate selectLikeSection:sender];
    }
}

@end
