//
//  MyLikeCache.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/19.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "MyLikeCache.h"

@implementation MyLikeCache

static MyLikeCache *instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [MyLikeCache sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [MyLikeCache sharedInstance];
}

- (MyLikeCache *)init {
    self = [super init];
    
    if (self) {
        NSDictionary *likedDcit = [[NSUserDefaults standardUserDefaults] objectForKey:@"LikedDict"];
        
        if (likedDcit) {
            _likedDict = [likedDcit mutableCopy];
        } else {
            _likedDict = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

- (BOOL)cacheLiked {
    AVQuery *query = [AVQuery queryWithClassName:@"Like"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query includeKey:@"journey"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //
        } else {
            for (int i = 0; i < objects.count; i++) {
                AVObject *journeyObject = objects[i][@"journey"];
                [_likedDict setObject:@YES forKey:journeyObject[@"objectId"]];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:_likedDict forKey:@"LikedDict"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }];
    
    return YES;
}

- (void)clearCache {
    [_likedDict removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_likedDict forKey:@"LikedDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLiked:(NSString *)dreamId {
    if([_likedDict objectForKey:dreamId]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addLike:(NSString *)dreamId {
    [_likedDict setObject:@YES forKey:dreamId];
    [[NSUserDefaults standardUserDefaults] setObject:_likedDict forKey:@"LikedDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeLike:(NSString *)dreamId {
    [_likedDict removeObjectForKey:dreamId];
    [[NSUserDefaults standardUserDefaults] setObject:_likedDict forKey:@"LikedDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
