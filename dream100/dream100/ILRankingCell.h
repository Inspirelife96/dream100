//
//  ILRankingCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/11.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILUserProfileDefaultView.h"

typedef NS_ENUM(NSInteger, ILRankType) {
    ILRankTypeDream,
    ILRankTypeJourney,
    ILRankTypeComment,
    ILRankTypeLike
};

@interface ILRankingCell : UITableViewCell

@property(weak, nonatomic) IBOutlet ILUserProfileDefaultView *userProfileDevaultView;
@property(weak, nonatomic) IBOutlet UILabel *countLabel;

@property(weak, nonatomic) id<ILUserProfileDefaultViewDelegate> delegate;

@property(strong, nonatomic) AVObject *countObject;
@property(assign, nonatomic) ILRankType rankType;

@end
