//
//  ILDreamModel.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILDreamModel : NSObject

@property(strong, nonatomic) NSString *dreamString;
@property(strong, nonatomic) NSArray *dreamImageArray;
@property(strong, nonatomic) NSString *dreamCategoryString;
@property(strong, nonatomic) NSNumber *dreamCostTime;
@property(strong, nonatomic) NSNumber *dreamCostMoney;
@property(strong, nonatomic) NSDate *dreamDeadLine;
@property(strong, nonatomic) NSDate *dreamCreatedAt;
@property(assign, nonatomic) BOOL isOpen;

@end
