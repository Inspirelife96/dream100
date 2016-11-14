//
//  DreamContentView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/8.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "DreamContentView.h"
#import "HZPhotoGroup.h"
#import "ILDreamModel.h"
#import "HZPhotoItem.h"
#import "UILabel+StringFrame.h"

@implementation DreamContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDreamObject:(AVObject *)dreamObject {
    _dreamObject = dreamObject;
    
    NSString *dreamString = dreamObject[@"content"];
    NSArray *dreamImageArray = dreamObject[@"imageFiles"];
    
    _contentLabel.text = dreamString;
    _contentLabel.font = GetFontAvenirNext(14.0f);
    _contentLabel.textColor = FlatGray;
    CGSize size = [_contentLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    _contentHeightConstraint.constant = size.height;
    
    _photoGroup.photoItemArray = nil;
    if (dreamImageArray.count > 0) {
        NSMutableArray *hzPhotoItemArray = [NSMutableArray array];
        for (int i = 0; i < dreamImageArray.count; i++) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init];
            item.thumbnail_pic = dreamImageArray[i];
            [hzPhotoItemArray addObject:item];
        }
        _photoGroup.photoItemArray = [hzPhotoItemArray copy];
    }
    
    if (dreamImageArray.count <= 0) {
        _photoHeightConstraint.constant = 0.0f;
    } else if (dreamImageArray.count <= 2) {
        _photoHeightConstraint.constant = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (dreamImageArray.count <= 5) {
        _photoHeightConstraint.constant = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        _photoHeightConstraint.constant = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    NSString *categoryString = @"##";
    
    if (dreamObject[@"category"] != nil && ![dreamObject[@"category"] isEqualToString:@""]) {
        categoryString = dreamObject[@"category"];
    }
    
    [_categoryButton setTitle:categoryString forState:UIControlStateNormal];    
}

+ (CGFloat)HeightForDreamContentView:(AVObject *)dreamObject {
    NSString *dreamString = dreamObject[@"content"];
    NSArray *dreamImageArray = dreamObject[@"imageFiles"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = dreamString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    
    CGFloat photoHeight = 0.0f;
    
    if (dreamImageArray.count <= 0) {
        photoHeight = 0.0f;
    } else if (dreamImageArray.count <= 2) {
        photoHeight = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (dreamImageArray.count <= 5) {
        photoHeight = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        photoHeight = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    return 8.0f + 44.0 + size.height + photoHeight + 8.0f;
}

@end
