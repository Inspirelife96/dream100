//
//  NSObject+LocalNotification.m
//  learnpaint
//
//  Created by Chen XueFeng on 16/8/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "NSObject+LocalNotification.h"

@implementation NSObject (LocalNotification)

- (void)postLocalNotification:(NSDate *)fireDate alertMessage:(NSString *)alertBody notificationInfo:(NSDictionary *)infoDict {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = fireDate;
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = NSCalendarUnitDay;
    //通知内容
    notification.alertBody = alertBody;
    //通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.userInfo = infoDict;
    
    //执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)cancelLocalNotification:(NSString *)keyString notificationId:(NSString*) idString {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification *notification in localNotifications) {
        if ([[notification.userInfo objectForKey:keyString] isEqualToString:idString]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
