//
//  MyDreamCache.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/17.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDreamCache : NSObject

+ (instancetype)sharedInstance;

@property(strong, nonatomic) NSMutableDictionary *myDreamDictionary;

- (BOOL)cacheMyDream;
- (void)clearCache;
- (BOOL)isMyDream:(NSString *)dreamId;
- (NSString *)getDreamStatus:(NSString *)dreamId;
- (void)addDream:(NSString *)dreamId;
- (void)removeDream:(NSString *)dreamId;


@end
