//
//  ILJourneyModel.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILJourneyModel : NSObject

@property(strong, nonatomic) NSString *journeyString;
@property(strong, nonatomic) NSArray *journeyImageArray;
@property(strong, nonatomic) NSDate *journeyCreatedAt;
@property(assign, nonatomic) BOOL isOpen;

@end
