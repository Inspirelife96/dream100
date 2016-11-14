//
//  ILDreamInspireCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/5.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamInspireCell.h"

@implementation ILDreamInspireCell

- (void)setInspireCellDict:(NSDictionary *)inspireCellDict {
    _categoryLabel.text = inspireCellDict[@"category"];
    _categoryLabel.font = GetFontAvenirNext(14.0f);
    _categoryLabel.textColor = FlatBlueDark;
    _categoryImageView.image = [UIImage imageNamed:inspireCellDict[@"categoryImage"]];
}

@end
