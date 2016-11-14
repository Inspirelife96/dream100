//
//  HZPhotoGroup.m
//  HZPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "HZPhotoGroup.h"
#import "HZPhotoItem.h"
#import "UIButton+WebCache.h"
#import "HZPhotoBrowser.h"

#define HZPhotoGroupImageMargin 15

@interface HZPhotoGroup () <HZPhotoBrowserDelegate>

@end

@implementation HZPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        //[[SDWebImageManager sharedManager].imageCache clearDisk];
    }
    return self;
}


- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(HZPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger imageCount = self.photoItemArray.count;
    
    if (imageCount <= 0) {
        return;
    }
//    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
//    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
//    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
//    CGFloat w = 80;
//    CGFloat h = 80;
    
    NSArray *photoLayout = [self calculatePhotoLayout:imageCount];
    NSInteger line0Count = [photoLayout[0] integerValue];
    NSInteger line1Count = (photoLayout.count > 1) ? ([photoLayout[1] integerValue] + line0Count) : 0;
    NSInteger line2Count = (photoLayout.count > 2) ? ([photoLayout[2] integerValue] + line1Count) : 0;
    
    CGFloat line0ImageWidth = ([[UIScreen mainScreen] bounds].size.width - 36.0f - ([photoLayout[0] integerValue] - 1) * 5.0f)/[photoLayout[0] integerValue];
    CGFloat line1ImageWidth = 0;
    if (photoLayout.count > 1) {
        line1ImageWidth = ([[UIScreen mainScreen] bounds].size.width - 36.0f - ([photoLayout[1] integerValue] - 1) * 5.0f)/[photoLayout[1] integerValue];
    }
    
    CGFloat line2ImageWidth = 0;
    if (photoLayout.count > 2) {
        line2ImageWidth = ([[UIScreen mainScreen] bounds].size.width - 36.0f - ([photoLayout[2] integerValue] - 1) * 5.0f)/[photoLayout[2] integerValue];
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        CGFloat xPos = 0.0f;
        CGFloat yPos = 0.0f;
        CGFloat width = 0.0f;
        CGFloat height = 128.0f;
        
        if (idx < line0Count) {
            xPos = idx * line0ImageWidth + idx * 5;
            yPos = 10.0f;
            width = line0ImageWidth;
        } else if (idx < line1Count) {
            xPos = (idx - line0Count) * line1ImageWidth + (idx - line0Count) * 5;
            yPos = 1 * height + 15.0f;
            width = line1ImageWidth;
        } else {
            xPos = (idx - line1Count) * line2ImageWidth + (idx - line1Count) * 5;
            yPos = 2 * height + 20.0f;
            width = line2ImageWidth;
        }
        
        btn.frame = CGRectMake(xPos, yPos, width, height);
    }];

    self.frame = CGRectMake(10.0f, 10.0f, [[UIScreen mainScreen] bounds].size.width - 36.0f, (128.0f *photoLayout.count) + (5.0f * photoLayout.count - 1) + 20.0f);
}

- (NSArray *)calculatePhotoLayout:(NSInteger)photoNumber {
    NSAssert((photoNumber >= 0) && (photoNumber <= 9), @"photo number is incorrect");
    if (photoNumber == 0) {
        return @[];
    } else if (photoNumber == 1) {
        return @[@1];
    } else if (photoNumber == 2) {
        return @[@2];
    } else if (photoNumber == 3) {
        return @[@2, @1];
    } else if (photoNumber == 4) {
        return @[@3, @1];
    } else if (photoNumber == 5) {
        return @[@3, @2];
    } else if (photoNumber == 6) {
        return @[@3, @2, @1];
    } else if (photoNumber == 7) {
        return @[@3, @3, @1];
    } else if (photoNumber == 8) {
        return @[@3, @3, @2];
    } else {
        return @[@3, @3, @3];
    }
}

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = (int)button.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
