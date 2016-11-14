//
//  AdManager.h
//  wowradio
//
//  Created by Chen XueFeng on 16/3/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdManager : NSObject

+(AdManager*) sharedInstance;

- (void)createInterstitial;
//- (void)createRewardedVideo;

//- (BOOL)isRewardedVideoReady;

//- (void)presentRewardedAdFromRootViewController:(UIViewController *)viewController;

- (BOOL)isInterstitialReady;

- (void)presentInterstitialAdFromRootViewController:(UIViewController *)viewController;

@end
