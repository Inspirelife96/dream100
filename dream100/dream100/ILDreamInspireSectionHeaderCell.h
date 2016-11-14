//
//  ILDreamInspireSectionHeaderCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QueryType) {
    QueryTypeSuggest,
    QueryTypeLatest
};

@protocol ILDreamInspireSectionHeaderCellDelegate <NSObject>

- (void)selectSuggest:(id)sender;
- (void)selectLatest:(id)sender;

@end

@interface ILDreamInspireSectionHeaderCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIButton *suggestButton;
@property(strong, nonatomic) IBOutlet UIButton *latestButton;
@property(weak, nonatomic) id<ILDreamInspireSectionHeaderCellDelegate> delegate;

- (void)setSuggestButtonEnable;
- (void)setlatestButtonEnable;

- (IBAction)clickSuggestButton:(id)sender;
- (IBAction)clickLatestButton:(id)sender;

@end
