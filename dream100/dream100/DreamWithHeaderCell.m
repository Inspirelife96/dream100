//
//  DreamWithHeaderCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "DreamWithHeaderCell.h"
#import "HZPhotoItem.h"
#import "UILabel+StringFrame.h"

@implementation DreamWithHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setDreamModel:(ILDreamModel *)dreamModel {
    _dreamModel = dreamModel;
    
    _contentLabel.text = dreamModel.dreamString;
    _contentLabel.font = GetFontAvenirNext(14.0f);
    _contentLabel.textColor = FlatGray;
    CGSize size = [_contentLabel boundingRectWithSize:CGSizeMake(self.frame.size.width - 20.0f, 0.0f) attributes:nil];
    _contentHeightConstraint.constant = size.height;
    
    if (dreamModel.dreamImageArray.count > 0) {
        NSMutableArray *hzPhotoItemArray = [NSMutableArray array];
        for (int i = 0; i < dreamModel.dreamImageArray.count; i++) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init];
            item.thumbnail_pic = dreamModel.dreamImageArray[i];
            [hzPhotoItemArray addObject:item];
        }
        _photoGroup.photoItemArray = [hzPhotoItemArray copy];
    }
    
    if (dreamModel.dreamImageArray.count <= 0) {
        _photoHeightConstraint.constant = 0.0f;
    } else if (dreamModel.dreamImageArray.count <= 2) {
        _photoHeightConstraint.constant = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (dreamModel.dreamImageArray.count <= 5) {
        _photoHeightConstraint.constant = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        _photoHeightConstraint.constant = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
}

@end
