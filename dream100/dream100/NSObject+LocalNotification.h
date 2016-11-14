//
//  NSObject+LocalNotification.h
//  learnpaint
//
//  Created by Chen XueFeng on 16/8/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LocalNotification)

- (void)postLocalNotification:(NSDate *)fireDate alertMessage:(NSString *)alertBody notificationInfo:(NSDictionary *)infoDict;
- (void)cancelLocalNotification:(NSString *)keyString notificationId:(NSString*) idString;

@end
