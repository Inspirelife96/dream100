//
//  ILDreamInspireSectionHeaderCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamInspireSectionHeaderCell.h"

@implementation ILDreamInspireSectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSuggestButtonEnable {
    [_suggestButton setSelected:YES];
    [_latestButton setSelected:NO];
}
- (void)setlatestButtonEnable {
    [_suggestButton setSelected:NO];
    [_latestButton setSelected:YES];
}

- (IBAction)clickSuggestButton:(id)sender {
    [self setSuggestButtonEnable];
    
    if([_delegate respondsToSelector:@selector(selectSuggest:)]) {
        [_delegate selectSuggest:sender];
    }
}

- (IBAction)clickLatestButton:(id)sender {
    [self setlatestButtonEnable];
    
    if([_delegate respondsToSelector:@selector(selectLatest:)]) {
        [_delegate selectLatest:sender];
    }
}

@end
