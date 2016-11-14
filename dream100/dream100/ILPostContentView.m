//
//  ILPostContentView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/22.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILPostContentView.h"
#import "UILabel+StringFrame.h"
#import "HZPhotoItem.h"

@implementation ILPostContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    _contentLabel.text = _contentString;
    _contentLabel.font = GetFontAvenirNext(14.0f);
    _contentLabel.textColor = FlatBlueDark;
    CGSize size = [_contentLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    _contentHeightConstraint.constant = size.height + 1.0f;
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    _photoGroup.photoItemArray = nil;
    if (imageArray.count > 0) {
        NSMutableArray *hzPhotoItemArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init];
            item.thumbnail_pic = imageArray[i];
            [hzPhotoItemArray addObject:item];
        }
        _photoGroup.photoItemArray = [hzPhotoItemArray copy];
    }
    
    _photoHeightConstraint.constant = [ILPostContentView HeightForImages:imageArray];
}

+ (CGFloat)HeightForContent:(NSString *)contentString {
    UILabel *label = [[UILabel alloc] init];
    label.text = contentString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    
    return size.height + 1.0f;
}

+ (CGFloat)HeightForImages:(NSArray *)imageArray {
    CGFloat imageHeight = 0.0f;
    
    if (imageArray == nil || imageArray.count <= 0) {
        imageHeight = 0.0f;
    } else if (imageArray.count <= 2) {
        imageHeight = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (imageArray.count <= 5) {
        imageHeight = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        imageHeight = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    return imageHeight;
}

@end
