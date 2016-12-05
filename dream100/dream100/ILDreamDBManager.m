//
//  ILDreamDBManager.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/26.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamDBManager.h"
#import "MyDreamCache.h"
#import "MyLikeCache.h"
#import "ILDreamModel.h"
#import "ILJourneyModel.h"

@implementation ILDreamDBManager

+ (void)createDream:(ILDreamModel *)dreamModel {
    dispatch_queue_t dispatchQueue = dispatch_queue_create("inspirelife.queue.save.dream", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    NSMutableArray *avFileArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < dreamModel.dreamImageArray.count; i++) {
        AVFile *file = [AVFile fileWithData:dreamModel.dreamImageArray[i]];
        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
            BOOL isSaved = [file save];
            if (isSaved) {
                [avFileArray addObject:file.url];
            } else {
                //
            }
        });
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            AVObject *dreamObject = [AVObject objectWithClassName:@"Dream"];
            [dreamObject setObject:dreamModel.dreamString forKey:@"content"];
            [dreamObject setObject:avFileArray forKey:@"imageFiles"];
            [dreamObject setObject:[AVUser currentUser] forKey:@"user"];
            [dreamObject setObject:dreamModel.dreamCategoryString forKey:@"category"];
            [dreamObject setObject:dreamModel.dreamCostTime forKey:@"costTime"];
            [dreamObject setObject:dreamModel.dreamCostMoney forKey:@"costMoney"];
            [dreamObject setObject:dreamModel.dreamDeadLine forKey:@"deadLine"];
            [dreamObject setObject:@(dreamModel.isOpen) forKey:@"isOpen"];
            [dreamObject setObject:@(0) forKey:@"followers"];
            [dreamObject setObject:@(0) forKey:@"journeys"];
            
            [dreamObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                }else {
                    [ILDreamDBManager joinDream:dreamObject];
                }
            }];
        });
    });
}

+ (void)joinDream:(AVObject*)dreamObject {
    AVObject *dreamFollowObject = [AVObject objectWithClassName:@"DreamFollow"];
    [dreamFollowObject setObject:dreamObject forKey:@"dream"];
    [dreamFollowObject setObject:[AVUser currentUser] forKey:@"user"];
    [dreamFollowObject setObject:@"追梦" forKey:@"status"];
    [dreamFollowObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [[MyDreamCache sharedInstance] addDream:dreamObject[@"objectId"]];
            [ILDreamDBManager addStandardJourney:ILJourneyTypeJoin toDream:dreamObject];
            [ILDreamDBManager updateFollowers:dreamObject];
            [ILDreamDBManager updateDreamCount:[AVUser currentUser]];
        }
    }];
}

+ (void)addStandardJourney:(ILJourneyType)journeyType toDream:(AVObject*)dreamObject {
    NSString *contentString = @"";
    
    switch (journeyType) {
        case ILJourneyTypeCreate:
            contentString = @"许下梦想!";
            break;
        case ILJourneyTypeJoin:
            contentString = @"许下梦想!";
            break;
        case ILJourneyTypeDailyCheck:
            contentString = @"正在为梦想而努力...";
            break;
        case ILJourneyTypeDone:
            contentString = @"圆梦！";
            break;
        case ILJourneyTypeQuit:
            contentString = @"放弃梦想!";
            break;
        case ILJourneyTypeCustomer:
            break;
    }
    
    AVObject *journey = [AVObject objectWithClassName:@"Journey"];
    [journey setObject:contentString forKey:@"content"];
    [journey setObject:@[] forKey:@"imageFiles"];
    [journey setObject:[AVUser currentUser] forKey:@"user"];
    [journey setObject:dreamObject forKey:@"dream"];
    [journey setObject:@0 forKey:@"likeNumber"];
    [journey setObject:@0 forKey:@"commentNumber"];
    [journey setObject:@(YES) forKey:@"isOpen"];
    [journey saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        }else {
            [ILDreamDBManager updateJourneys:dreamObject];
            [ILDreamDBManager updateJourneyCount:[AVUser currentUser]];
        }
    }];
}

+ (void)addCustomJourney:(ILJourneyModel *)journeyModel toDream:(AVObject*)dreamObject {
    dispatch_queue_t dispatchQueue = dispatch_queue_create("inspirelife.queue.save.dream", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    NSMutableArray *avFileArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < journeyModel.journeyImageArray.count; i++) {
        AVFile *file = [AVFile fileWithData:journeyModel.journeyImageArray[i]];
        dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
            BOOL isSaved = [file save];
            if (isSaved) {
                [avFileArray addObject:file.url];
            } else {
                //
            }
        });
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            AVObject *journey = [AVObject objectWithClassName:@"Journey"];
            [journey setObject:journeyModel.journeyString forKey:@"content"];
            [journey setObject:avFileArray forKey:@"imageFiles"];
            [journey setObject:[AVUser currentUser] forKey:@"user"];
            [journey setObject:dreamObject forKey:@"dream"];
            [journey setObject:@0 forKey:@"likeNumber"];
            [journey setObject:@0 forKey:@"commentNumber"];
            [journey setObject:@(journeyModel.isOpen) forKey:@"isOpen"];
            
            [journey saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                }else {
                    [ILDreamDBManager updateJourneys:dreamObject];
                    [ILDreamDBManager updateJourneyCount:[AVUser currentUser]];
                }
            }];
        });
    });
}

+ (void)removeDream:(AVObject*)dreamObject {
    AVQuery *query = [AVQuery queryWithClassName:@"DreamFollow"];
    [query whereKey:@"dream" equalTo:dreamObject];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                } else {
                    [[MyDreamCache sharedInstance] removeDream:dreamObject[@"objectId"]];
                    [ILDreamDBManager addStandardJourney:ILJourneyTypeQuit toDream:dreamObject];
                    [ILDreamDBManager updateFollowers:dreamObject];
                    [ILDreamDBManager updateDreamCount:[AVUser currentUser]];
                }
            }];
        }
    }];
}

+ (void)updateDreamCount:(AVUser *)userObject {
    AVQuery *followCountQuery = [AVQuery queryWithClassName:@"DreamFollow"];
    [followCountQuery whereKey:@"user" equalTo:userObject];
    [followCountQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
           //[ILDreamDBManager postNotificationWithError:error];
        } else {
            AVQuery *dreamCountQuery = [AVQuery queryWithClassName:@"DreamCount"];
            [dreamCountQuery whereKey:@"user" equalTo:userObject];
            [dreamCountQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    //[ILDreamDBManager postNotificationWithError:error];
                } else {
                    [object setObject:@(number) forKey:@"dreamCount"];
                    [object saveEventually];
                }
            }];
        }
    }];
}

+ (void)updateCommentCount:(AVUser *)userObject {
    AVQuery *followCountQuery = [AVQuery queryWithClassName:@"Comment"];
    [followCountQuery whereKey:@"fromUser" equalTo:userObject];
    [followCountQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            //[ILDreamDBManager postNotificationWithError:error];
        } else {
            AVQuery *dreamCountQuery = [AVQuery queryWithClassName:@"DreamCount"];
            [dreamCountQuery whereKey:@"user" equalTo:userObject];
            [dreamCountQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    //[ILDreamDBManager postNotificationWithError:error];
                } else {
                    [object setObject:@(number) forKey:@"commentCount"];
                    [object saveEventually];
                }
            }];
        }
    }];
}

+ (void)updateLikeCount:(AVUser *)userObject {
    AVQuery *followCountQuery = [AVQuery queryWithClassName:@"Like"];
    [followCountQuery whereKey:@"fromUser" equalTo:userObject];
    [followCountQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            //[ILDreamDBManager postNotificationWithError:error];
        } else {
            AVQuery *dreamCountQuery = [AVQuery queryWithClassName:@"DreamCount"];
            [dreamCountQuery whereKey:@"user" equalTo:userObject];
            [dreamCountQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    //[ILDreamDBManager postNotificationWithError:error];
                } else {
                    [object setObject:@(number) forKey:@"likeCount"];
                    [object saveEventually];
                }
            }];
        }
    }];
}

+ (void)updateJourneyCount:(AVUser *)userObject {
    AVQuery *followCountQuery = [AVQuery queryWithClassName:@"Journey"];
    [followCountQuery whereKey:@"user" equalTo:userObject];
    [followCountQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            //[ILDreamDBManager postNotificationWithError:error];
        } else {
            AVQuery *dreamCountQuery = [AVQuery queryWithClassName:@"DreamCount"];
            [dreamCountQuery whereKey:@"user" equalTo:userObject];
            [dreamCountQuery getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (error) {
                    //[ILDreamDBManager postNotificationWithError:error];
                } else {
                    [object setObject:@(number) forKey:@"journeyCount"];
                    [object saveEventually];
                }
            }];
        }
    }];
}

+ (void)updateFollowers:(AVObject *)dreamObject {
    AVQuery *followQuery = [AVQuery queryWithClassName:@"DreamFollow"];
    [followQuery whereKey:@"dream" equalTo:dreamObject];
    [followQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [dreamObject setObject:@(number) forKey:@"followers"];
            [dreamObject saveEventually];
        }
    }];
}

+ (void)updateJourneys:(AVObject *)dreamObject {
    AVQuery *journeyQuery = [AVQuery queryWithClassName:@"Journey"];
    [journeyQuery whereKey:@"dream" equalTo:dreamObject];
    [journeyQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [dreamObject setObject:@(number) forKey:@"journeys"];
            [dreamObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ILDreamUIUpdateNotification" object:nil];
                }
            }];
        }
    }];
}

+ (void)updateLikeNumber:(AVObject *)journeyObject {
    AVQuery *followQuery = [AVQuery queryWithClassName:@"Like"];
    [followQuery whereKey:@"journey" equalTo:journeyObject];
    [followQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            //[ILDreamDBManager postNotificationWithError:error];
        } else {
            [journeyObject setObject:@(number) forKey:@"likeNumber"];
            [journeyObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(error) {
                    //[ILDreamDBManager postNotificationWithError:error];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ILJourneyLikeUpdateNotification" object:nil];
                }
            }];
        }
    }];
}

+ (void)updateCommentNumber:(AVObject *)journeyObject {
    AVQuery *followQuery = [AVQuery queryWithClassName:@"Comment"];
    [followQuery whereKey:@"journey" equalTo:journeyObject];
    [followQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [journeyObject setObject:@(number) forKey:@"commentNumber"];
            [journeyObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ILJourneyCommentUpdateNotification" object:nil];                    
                }
            }];
        }
    }];
}

+ (void)addLike:(AVObject *)journeyObject {
    AVObject *likeObject = [AVObject objectWithClassName:@"Like"];
    [likeObject setObject:[AVUser currentUser] forKey:@"fromUser"];
    [likeObject setObject:journeyObject[@"user"] forKey:@"toUser"];
    [likeObject setObject:journeyObject forKey:@"journey"];
    [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [self pushMessage:@"like" toUser:journeyObject[@"user"] ForJourney:journeyObject];
            [[MyLikeCache sharedInstance] addLike:journeyObject[@"objectId"]];
            [ILDreamDBManager updateLikeNumber:journeyObject];
            [ILDreamDBManager updateLikeCount:[AVUser currentUser]];
        }
    }];
}

+ (void)removeLike:(AVObject *)journeyObject {
    AVQuery *query = [AVQuery queryWithClassName:@"Like"];
    [query whereKey:@"fromUser" equalTo:[AVUser currentUser]];
    [query whereKey:@"journey" equalTo:journeyObject];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [[MyLikeCache sharedInstance] removeLike:journeyObject[@"objectId"]];
                [ILDreamDBManager updateLikeNumber:journeyObject];
                [ILDreamDBManager updateLikeCount:[AVUser currentUser]];
            }];
        }
    }];
}

+ (void)addComment:(NSString *)commentString toUser:(AVUser *)toUser onJourney:(AVObject *)journeyObject {
    AVObject *object = [AVObject objectWithClassName:@"Comment"];
    [object setObject:commentString forKey:@"comment"];
    [object setObject:journeyObject forKey:@"journey"];
    [object setObject:[AVUser currentUser] forKey:@"fromUser"];
    [object setObject:toUser forKey:@"toUser"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [ILDreamDBManager postNotificationWithError:error];
        } else {
            [self pushMessage:@"comment" toUser:toUser ForJourney:journeyObject];
            [ILDreamDBManager updateCommentNumber:journeyObject];
            [ILDreamDBManager updateCommentCount:[AVUser currentUser]];
        }
    }];
}

+ (void)addTipoffs:(ILTipoffsType)type toObject:(AVObject *)object {
    AVObject *tipOffsObject = [AVObject objectWithClassName:@"Tipoffs"];
    [tipOffsObject setObject:@(type) forKey:@"type"];
    [tipOffsObject setObject:object forKey:@"object"];
    [tipOffsObject setObject:[AVUser currentUser] forKey:@"user"];
    [tipOffsObject saveEventually];
}

+ (void)pushMessage:(NSString*)messageType toUser:(AVUser *)userObject ForJourney:(AVObject*)journeyObject {
    AVQuery *pushQuery = [AVInstallation query];
    if (userObject == nil) {
        [pushQuery whereKey:@"owner" equalTo:journeyObject[@"user"]];
    } else {
        [pushQuery whereKey:@"owner" equalTo:userObject];
    }
    
    AVObject *dreamObject = journeyObject[@"dream"];
    
    NSString *dreamId = dreamObject.objectId;
    NSString *dreamContent = dreamObject[@"content"];
    if (dreamContent.length >= 10) {
        dreamContent = [NSString stringWithFormat:@"%@...", [dreamContent substringToIndex:7]];
    }
    
    NSString *journeyContent = journeyObject[@"content"];
    if (journeyContent.length >= 10) {
        journeyContent = [NSString stringWithFormat:@"%@...", [journeyContent substringToIndex:7]];
    }
    
    NSString *journeyId = journeyObject.objectId;
    NSString *alertMessage = nil;
    NSDictionary *data = nil;
    if ([messageType isEqualToString:@"like"]) {
        alertMessage = [NSString stringWithFormat:@"%@赞了您在梦想[%@]发布的心路历程[%@]", [AVUser currentUser].username,dreamContent, journeyContent];
        data = @{
                  @"alert": alertMessage,
                  @"badge": @"Increment",
                  @"likebadge": @"Increment",
                  @"sound": @"cheering.caf",
                  @"type": messageType,
                  @"dreamId": dreamId,
                  @"journeyId": journeyId,
                  };
    } else {
        alertMessage = [NSString stringWithFormat:@"%@在梦想[%@]的心路历程[%@]中添加了一条评论", [AVUser currentUser].username,dreamContent, journeyContent];
        data = @{
                  @"alert": alertMessage,
                  @"badge": @"Increment",
                  @"commentbadge": @"Increment",
                  @"sound": @"cheering.caf",
                  @"type": messageType,
                  @"dreamId": dreamId,
                  @"journeyId": journeyId,
                  };
    }
    
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackground];
    
    if ([messageType isEqualToString:@"like"]) {
        [ILDreamDBManager updateBadge:1 forUser:journeyObject[@"user"]];
    } else {
        [ILDreamDBManager updateBadge:0 forUser:journeyObject[@"user"]];
    }
}

+ (void)AddMessageListFrom:(AVUser *)fromUser to:(AVUser *)toUser message:(NSString *)messageString {
    AVQuery *queryFrom = [AVQuery queryWithClassName:@"MessageList"];
    [queryFrom whereKey:@"fromUser" equalTo:fromUser];
    [queryFrom whereKey:@"toUser" equalTo:toUser];
    
    AVQuery *queryTo = [AVQuery queryWithClassName:@"MessageList"];
    [queryTo whereKey:@"fromUser" equalTo:toUser];
    [queryTo whereKey:@"toUser" equalTo:fromUser];
    
    AVQuery *query = [AVQuery orQueryWithSubqueries:@[queryFrom, queryTo]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            if (error.code == 101) {
                AVObject *messageListObject = [AVObject objectWithClassName:@"MessageList"];
                [messageListObject setObject:fromUser forKey:@"fromUser"];
                [messageListObject setObject:toUser forKey:@"toUser"];
                [messageListObject setObject:messageString forKey:@"message"];
                [messageListObject saveEventually];
            } else {
                [ILDreamDBManager postNotificationWithError:error];
            }
        } else {
            if (objects.count > 0) {
                AVObject *messageListObject = objects[0];
                [messageListObject setObject:messageString forKey:@"message"];
                [messageListObject saveEventually];
            } else {
                // insert one record
                AVObject *messageListObject = [AVObject objectWithClassName:@"MessageList"];
                [messageListObject setObject:fromUser forKey:@"fromUser"];
                [messageListObject setObject:toUser forKey:@"toUser"];
                [messageListObject setObject:messageString forKey:@"message"];
                [messageListObject saveEventually];
            }
        }
    }];
}

+ (void)pushMessage:(NSString *)message toUser:(AVUser *)toUser {
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:@"owner" equalTo:toUser];
    
    NSString *alertMessage = [NSString stringWithFormat:@"%@：%@", [AVUser currentUser].username, message];
    
    NSDictionary *data = @{
             @"alert": alertMessage,
             @"badge": @"Increment",
             @"sound": @"cheering.caf",
             };
    
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];
    [push setData:data];
    [push sendPushInBackground];
    
    [ILDreamDBManager updateBadge:2 forUser:toUser];
}

+ (void)updateBadge:(NSInteger)type forUser:(AVUser *)userObject {
    AVQuery *query = [AVQuery queryWithClassName:@"BadgeCount"];
    [query whereKey:@"user" equalTo:userObject];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            if (error.code == 101) {
                AVObject *badgeCountObject = [AVObject objectWithClassName:@"BadgeCount"];
                [badgeCountObject setObject:[AVUser currentUser] forKey:@"user"];
                [badgeCountObject setObject:@(0) forKey:@"commentBadge"];
                [badgeCountObject setObject:@(0) forKey:@"likeBadge"];
                [badgeCountObject setObject:@(0) forKey:@"messageBadge"];
                [badgeCountObject setObject:@(0) forKey:@"followerBadge"];
                [badgeCountObject saveEventually];
            } else {
                //[ILDreamDBManager postNotificationWithError:error];
            }
        } else {
            if (type == 0) {
                //评论
                NSInteger commentBadge = [object[@"commentBadge"] integerValue];
                [object setObject:@(commentBadge + 1) forKey:@"commentBadge"];
                [object saveInBackground];
            } else if (type == 1) {
                //喜欢
                NSInteger likeBadge = [object[@"likeBadge"] integerValue];
                [object setObject:@(likeBadge + 1) forKey:@"likeBadge"];
                [object saveInBackground];
            } else if (type == 2) {
                //信件
                NSInteger messageBadge = [object[@"messageBadge"] integerValue];
                [object setObject:@(messageBadge + 1) forKey:@"messageBadge"];
                [object saveInBackground];
            } else if (type == 3) {
                //关注
                NSInteger followerBadge = [object[@"followerBadge"] integerValue];
                [object setObject:@(followerBadge + 1) forKey:@"followerBadge"];
                [object saveInBackground];
            }
        }
    }];
}

+ (void)resetBadge:(NSInteger)type  {
    AVQuery *query = [AVQuery queryWithClassName:@"BadgeCount"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            //[ILDreamDBManager postNotificationWithError:error];
        } else {
            NSNumber *commentNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentBadge"];
            NSNumber *likeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"likeBadge"];
            NSNumber *messageNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"messageBadge"];
            NSNumber *followerNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"followerBadge"];
            NSInteger badgeNumber = [commentNumber integerValue]
            + [likeNumber integerValue]
            + [messageNumber integerValue]
            + [followerNumber integerValue];

            if (type == 0) {
                //评论
                NSInteger commentBadge = [object[@"commentBadge"] integerValue];
                badgeNumber = badgeNumber - commentBadge;
                [object setObject:@(0) forKey:@"commentBadge"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"commentBadge"];
            } else if (type == 1) {
                //喜欢
                NSInteger likeBadge = [object[@"likeBadge"] integerValue];
                badgeNumber = badgeNumber - likeBadge;
                [object setObject:@(0) forKey:@"likeBadge"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"likeBadge"];
            } else if (type == 2) {
                //信件
                NSInteger messageBadge = [object[@"messageBadge"] integerValue];
                badgeNumber = badgeNumber - messageBadge;
                [object setObject:@(0) forKey:@"messageBadge"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"messageBadge"];
            } else if (type == 3) {
                //关注
                NSInteger followerBadge = [object[@"followerBadge"] integerValue];
                badgeNumber = badgeNumber - followerBadge;
                [object setObject:@(0) forKey:@"followerBadge"];
                [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"followerBadge"];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    [ILDreamDBManager postNotificationWithError:error];
                } else {
                    [ILDreamDBManager resetInstallationBadge:badgeNumber];
                }
            }];
        }
    }];
}

+ (void)resetInstallationBadge:(NSInteger)installationNumber {
    NSInteger badgeNumber = installationNumber;
    if (badgeNumber < 0) {
        badgeNumber = 0;
    }
    [[AVInstallation currentInstallation] setObject:@(badgeNumber) forKey:@"badge"];
    [[AVInstallation currentInstallation] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
        if (error) {
            
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ILBadgeUpdateNotification" object:nil];
        }
    }];
}

+ (void)fetchBadge  {
    AVQuery *query = [AVQuery queryWithClassName:@"BadgeCount"];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            //
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:object[@"commentBadge"] forKey:@"commentBadge"];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"likeBadge"] forKey:@"likeBadge"];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"messageBadge"] forKey:@"messageBadge"];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"followerBadge"] forKey:@"followerBadge"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ILBadgeUpdateNotification" object:nil];
        }
    }];
}

+ (void)postNotificationWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ILDreamDBOperationErrorNotification" object:@[error]];
}


@end
