//
//  ILDiscoverySectionHeaderCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/6.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QueryType) {
    QueryTypeHot,
    QueryTypeLatest,
    QueryTypeFollow,
    QueryTypeFamous
};

@protocol ILDiscoverySectionHeaderCellDelegate <NSObject>

- (void)selectHotButton:(id)sender;
- (void)selectLatestButton:(id)sender;
- (void)selectFollowButton:(id)sender;

@end


@interface ILDiscoverySectionHeaderCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIButton *hotButton;
@property(strong, nonatomic) IBOutlet UIButton *latestButton;
@property(strong, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, weak) id<ILDiscoverySectionHeaderCellDelegate> delegate;

- (void)setHotButtonSelected;
- (void)setLatestButtonSelected;
- (void)setfollowButtonSelected;

- (IBAction)clickHotButton:(id)sender;
- (IBAction)clickLatestButton:(id)sender;
- (IBAction)clickFollowButton:(id)sender;

@end
