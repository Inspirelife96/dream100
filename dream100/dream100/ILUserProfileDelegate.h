//
//  ILUserProfileDelegate.h
//  dream100
//
//  Created by Chen XueFeng on 16/11/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ILCommentMessageCellDelegate <NSObject>

- (void)clickUser:(AVUser *)userObject;
- (void)clickDream:(AVObject *)dreamObject;
- (void)clickJourney:(AVObject *)journeyObject;

@end

@protocol ILUserProfileWithReplyViewDelegate <NSObject>

- (void)clickReply:(AVObject *)commentObject;

@end

@protocol ILUserProfileDefaultViewDelegate <NSObject>

- (void)clickProfile:(AVUser *)userObject;

@end

@protocol ILUserProfileDelegate <NSObject>

- (void)clickUserProfile:(id)sender;
- (void)clickFollow:(id)sender;
- (void)clickMessage:(id)sender;
- (void)clickReply:(id)sender;

@end
