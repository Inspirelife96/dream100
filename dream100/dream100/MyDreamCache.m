//
//  MyDreamCache.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/17.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "MyDreamCache.h"

@implementation MyDreamCache

static MyDreamCache *instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [MyDreamCache sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    
    return [MyDreamCache sharedInstance];
}

- (MyDreamCache *)init {
    self = [super init];
    
    if (self) {
        NSDictionary *cachedDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"myDreamCache"];
        
        if (cachedDict) {
            _myDreamDictionary = [cachedDict mutableCopy];
        } else {
            _myDreamDictionary = [[NSMutableDictionary alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:_myDreamDictionary forKey:@"myDreamCache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return self;
}

- (BOOL)cacheMyDream {
    AVQuery *query = [AVQuery queryWithClassName:@"DreamFollow"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query includeKey:@"dream"];
    
    NSError *error;
    NSArray *myDreamArray = [query findObjects:&error];
    if (error) {
        return NO;
    } else {
        for (int i = 0; i < myDreamArray.count; i++) {
            AVObject *dream = myDreamArray[i][@"dream"];
            [_myDreamDictionary setObject: myDreamArray[i][@"status"] forKey:dream[@"objectId"]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_myDreamDictionary forKey:@"myDreamCache"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

- (void)clearCache {
    [_myDreamDictionary removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_myDreamDictionary forKey:@"myDreamCache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isMyDream:(NSString *)dreamId {
    if([_myDreamDictionary objectForKey:dreamId]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)getDreamStatus:(NSString *)dreamId {
    return [_myDreamDictionary objectForKey:dreamId];
}

- (void)addDream:(NSString *)dreamId {
    [_myDreamDictionary setObject:@"追梦者" forKey:dreamId];
    [[NSUserDefaults standardUserDefaults] setObject:_myDreamDictionary forKey:@"myDreamCache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeDream:(NSString *)dreamId {
    [_myDreamDictionary removeObjectForKey:dreamId];
    [[NSUserDefaults standardUserDefaults] setObject:_myDreamDictionary forKey:@"myDreamCache"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
