//
//  AppDelegate.m
//  dream100
//
//  Created by Chen XueFeng on 16/9/24.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//#import <LeanCloudSocial/AVOSCloudSNS.h>

#import "iRate.h"

#import <UserNotifications/UserNotifications.h>
#import "ILDreamDBManager.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

+ (void)initialize {
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 5;
    [iRate sharedInstance].usesUntilPrompt = 15;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerForRemoteNotification];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    // init leancloud
    [AVOSCloud setApplicationId:kLeanCloudApplicationId
                      clientKey:kLeanClientKey];
    
    [ShareSDK registerApp:kShareSDKApplicationId
          activePlatforms:@[
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:kWXApplicationId
                                            appSecret:kWXApplicationSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:kQQApplicationId
                                           appKey:kQQApplicationSecret
                                         authType:SSDKAuthTypeBoth];
                  default:
                      break;
              }
          }];
    
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    if (![userDefault boolForKey:kUserDefaultFirstLaunch]) {
        [userDefault setBool:YES forKey:kUserDefaultFirstLaunch];
//        [userDefault setBool:NO  forKey:kUserDefaultIsVip];
//        [userDefault setBool:NO  forKey:kUserDefaultIsAdRemoved];
//        [userDefault setBool:NO  forKey:kUserDefaultIsSharedToday];
//        [userDefault setObject:@"10:00:00"  forKey:kUserDefaultDailyNotification];
//        [userDefault setBool:YES  forKey:kUserDefaultDailyNotificationStatus];
        [userDefault setObject:@0  forKey:@"commentBadge"];
        [userDefault setObject:@0  forKey:@"likeBadge"];
        [userDefault setObject:@0  forKey:@"messageBadge"];
        [userDefault setObject:@0  forKey:@"followerBadge"];
        [userDefault setObject:@0  forKey:@"totalBadge"];
        
        [userDefault synchronize];
    }
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([AVUser currentUser]) {
//        NSInteger badgeNumber = [AVInstallation currentInstallation].badge;
//        UITabBarController  *tabbarController = (UITabBarController *)self.window.rootViewController;
//        if (badgeNumber > 0) {
//            NSString *badgeString = [NSString stringWithFormat:@"%ld", badgeNumber];
//            [[[[tabbarController tabBar] items] objectAtIndex:4] setBadgeValue:badgeString];
//
//        } else {
//            [[[[tabbarController tabBar] items] objectAtIndex:4] setBadgeValue:nil];
//        }
        [ILDreamDBManager fetchBadge];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

#pragma -
#pragma mark - Other Method

#pragma mark - 初始化UNUserNotificationCenter
///=============================================================================
/// @name 初始化UNUserNotificationCenter
///=============================================================================

/**
 * 初始化UNUserNotificationCenter
 */
- (void)registerForRemoteNotification {
    // iOS10 兼容
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *uncenter = [UNUserNotificationCenter currentNotificationCenter];
        // 监听回调事件
        [uncenter setDelegate:self];
        //iOS10 使用以下方法注册，才能得到授权
        [uncenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert+UNAuthorizationOptionBadge+UNAuthorizationOptionSound)
                                completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                    //TODO:授权状态改变
                                    NSLog(@"%@" , granted ? @"授权成功" : @"授权失败");
                                }];
        // 获取当前的通知授权状态, UNNotificationSettings
        [uncenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%s\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), settings);
            /*
             UNAuthorizationStatusNotDetermined : 没有做出选择
             UNAuthorizationStatusDenied : 用户未授权
             UNAuthorizationStatusAuthorized ：用户已授权
             */
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                NSLog(@"未选择");
            } else if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                NSLog(@"未授权");
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"已授权");
            }
        }];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
#pragma clang diagnostic pop
}

#pragma mark UNUserNotificationCenterDelegate

#pragma mark - 添加处理 APNs 通知回调方法
///=============================================================================
/// @name 添加处理APNs通知回调方法
///=============================================================================

#pragma mark -
#pragma mark - UNUserNotificationCenterDelegate Method

#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8

/**
 * Required for iOS 10+
 * 在前台收到推送内容, 执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSLog(@"%@", userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}

/**
 * Required for iOS 10+
 * 在后台和启动之前收到推送内容, 执行的方法
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //TODO:处理远程推送内容
        NSLog(@"%@", userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionBadge + UNNotificationPresentationOptionSound + UNNotificationPresentationOptionAlert);
}

#endif

#pragma mark -
#pragma mark - UIApplicationDelegate Method

/*!
 * Required for iOS 7+
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //TODO:处理远程推送内容
    NSLog(@"%@", userInfo);
    // Must be called when finished
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 实现注册APNs失败接口（可选）
///=============================================================================
/// @name 实现注册APNs失败接口（可选）
///=============================================================================

/**
 * also used in iOS10
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%s\n[无法注册远程提醒, 错误信息]\nline:%@\n-----\n%@\n\n", __func__, @(__LINE__), error);
}


@end
