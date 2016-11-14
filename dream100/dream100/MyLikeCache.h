//
//  MyLikeCache.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/19.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyLikeCache : NSObject

+ (instancetype)sharedInstance;

@property(strong, nonatomic) NSMutableDictionary *likedDict;

- (BOOL)cacheLiked;
- (void)clearCache;
- (BOOL)isLiked:(NSString *)journeyId;
- (void)addLike:(NSString *)journeyId;
- (void)removeLike:(NSString *)journeyId;

@end
