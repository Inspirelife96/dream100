//
//  ILDreamInspireCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/5.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILDreamInspireCell : UICollectionViewCell

@property(strong, nonatomic) IBOutlet UIImageView *categoryImageView;
@property(strong, nonatomic) IBOutlet UILabel *categoryLabel;

@property(strong, nonatomic) NSDictionary *inspireCellDict;

@end
