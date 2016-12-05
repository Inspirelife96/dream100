//
//  ILDreamDBManager.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILDreamModel.h"
#import "ILJourneyModel.h"

typedef NS_ENUM(NSInteger, ILJourneyType) {
    ILJourneyTypeCreate,
    ILJourneyTypeJoin,
    ILJourneyTypeDailyCheck,
    ILJourneyTypeDone,
    ILJourneyTypeQuit,
    ILJourneyTypeCustomer
};

typedef NS_ENUM(NSInteger, ILTipoffsType) {
    ILTipoffsType0,
    ILTipoffsType1,
    ILTipoffsType2,
    ILTipoffsType3
};


@interface ILDreamDBManager : NSObject

+ (void)createDream:(ILDreamModel *)dreamModel;
+ (void)joinDream:(AVObject*)dreamObject;
+ (void)removeDream:(AVObject*)dreamObject;
+ (void)updateFollowers:(AVObject *)dreamObject;
+ (void)updateJourneys:(AVObject *)dreamObject;
+ (void)updateDreamCount:(AVUser *)userObject;

+ (void)addStandardJourney:(ILJourneyType)journeyType toDream:(AVObject*)dreamObject;
+ (void)addCustomJourney:(ILJourneyModel *)journeyModel toDream:(AVObject*)dreamObject;

+ (void)updateLikeNumber:(AVObject *)journeyObject;
+ (void)updateCommentNumber:(AVObject *)journeyObject;
+ (void)addLike:(AVObject *)journeyObject;
+ (void)removeLike:(AVObject *)journeyObject;
+ (void)addComment:(NSString *)commentString toUser:(AVUser *)toUser onJourney:(AVObject *)journeyObject;

+ (void)addTipoffs:(ILTipoffsType)type toObject:(AVObject *)object;

+ (void)AddMessageListFrom:(AVUser *)fromUser to:(AVUser *)toUser message:(NSString *)messageString;
+ (void)pushMessage:(NSString *)message toUser:(AVUser *)toUser;
+ (void)updateBadge:(NSInteger)type forUser:(AVUser *)userObject;
+ (void)resetBadge:(NSInteger)type;
+ (void)fetchBadge;

@end
