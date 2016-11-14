//
//  ILDreamCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamCell.h"
#import "MyDreamCache.h"

@implementation ILDreamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setDreamObject:(AVObject *)dreamObject {
    _dreamObject = dreamObject;
    
    NSString *categoryString = @"标签:#未设置#";
    if (dreamObject[@"category"] != nil && ![dreamObject[@"category"] isEqualToString:@""]) {
        categoryString = [NSString stringWithFormat:@"标签:%@", dreamObject[@"category"]];
    }
    [_categoryButton setTitle:categoryString forState:UIControlStateNormal];

    _postContentView.contentString = dreamObject[@"content"];
    _postContentView.imageArray = dreamObject[@"imageFiles"];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", dreamObject[@"createdAt"]];
    
    _dreamStatusLabel.text = [NSString stringWithFormat:@"共梦者(%ld) ｜ 心路历程(%ld)", (long)[_dreamObject[@"followers"] integerValue], (long)[_dreamObject[@"journeys"] integerValue]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[MyDreamCache sharedInstance] isMyDream:dreamObject[@"objectId"]]) {
        _postContentView.layer.shadowOpacity = 1.0f;
        _postContentView.layer.shadowOffset = CGSizeMake(0,3);
        _postContentView.layer.shadowRadius = 10.0f;
        _postContentView.layer.shadowColor = FlatRed.CGColor;
    } else {
        _postContentView.layer.shadowOpacity = 0.0f;
        _postContentView.layer.shadowOffset = CGSizeMake(0,0);
        _postContentView.layer.shadowRadius = 0.0f;
        _postContentView.layer.shadowColor = [UIColor clearColor].CGColor;
    }
}

+ (CGFloat)HeightForDreamCell:(AVObject *)dreamObject {
    CGFloat contentHeight = [ILPostContentView HeightForContent:dreamObject[@"content"]];
    CGFloat imageHeight = [ILPostContentView HeightForImages:dreamObject[@"imageFiles"]];
    
    return 8.0f + 44.0 + contentHeight + imageHeight + 44.0f + 8.0f;
}

- (IBAction)clickActionButton:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectAction:)]) {
        [_delegate selectAction:sender];
    }
}

@end

