//
//  CDCommon.h
//  LeanChat
//
//  Created by Qihe Bian on 7/29/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#ifndef LeanChat_CDCommon_h
#define LeanChat_CDCommon_h

#import <AVOSCloud/AVOSCloud.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define USE_US 0
#if !USE_US
//国内节点
//#error 在这里设置你自己的AppID和AppKey，设置好了删除此行
#define AVOSAppID @"dSkvGkevuXMDI6keRiYFLzd1-gzGzoHsz"
#define AVOSAppKey @"c1kgDem6Xe3GbWoQLsIbDQK8"

#else
//北美节点
//#error 在这里设置你自己的AppID和AppKey，设置好了删除此行
#define AVOSAppID @""
#define AVOSAppKey @""
#endif

#define WeChatAppId @"wx18c65b310d0a12d7"
#define WeChatSecretKey @"0ae5b76ceb716ba86b950cf3a9e79378"
#define QQAppId @"1105283378"
#define QQAppKey @"NTBdMnWhSsi2vTPq"
//#define WeiboAppId @"2548122881"
//#define WeiboAppKey @"ba37a6eb3018590b0d75da733c4998f8"

#define RGBCOLOR(r, g, b) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : 1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : (a)]
#define UIColorFromRGB(rgb) [UIColor colorWithRed : ((rgb) & 0xFF0000 >> 16) / 255.0 green : ((rgb) & 0xFF00 >> 8) / 255.0 blue : ((rgb) & 0xFF) / 255.0 alpha : 1.0]

#define NAVIGATION_COLOR_MALE RGBCOLOR(40, 130, 226)
#define NAVIGATION_COLOR_FEMALE RGBCOLOR(215, 81, 67)
#define NAVIGATION_COLOR_SQUARE RGBCOLOR(248, 248, 248)
#define NAVIGATION_COLOR_LEANCHAT RGBCOLOR(40, 130, 226)
#define NORMAL_BACKGROUD_COLOR RGBCOLOR(235, 235, 242)

#define NAVIGATION_COLOR NAVIGATION_COLOR_LEANCHAT

#define CD_FONT_COLOR RGBCOLOR(0, 0, 0)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define INSTALLATION @"installation"
#define SETTING @"setting"

#define KEY_USERNAME @"KEY_USERNAME"
#define USERNAME_MIN_LENGTH 3
#define PASSWORD_MIN_LENGTH 3

#define CD_COMMON_ROW_HEIGHT 44

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#   define DLog(...)
#endif

#define WEAKSELF  typeof(self) __weak weakSelf = self;

#define SELECTOR_TO_STRING(sel) NSStringFromSelector(@selector(sel))

#endif
