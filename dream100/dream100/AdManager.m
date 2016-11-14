//
//  AdManager.m
//  wowradio
//
//  Created by Chen XueFeng on 16/3/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "AdManager.h"

@import GoogleMobileAds;

@interface AdManager() <GADRewardBasedVideoAdDelegate, GADInterstitialDelegate> {
    
    GADInterstitial *gadInterstitialNormal;
}

@end

@implementation AdManager

static AdManager *instance = nil;

+(AdManager*) sharedInstance {
    
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return instance;
}

+(id) allocWithZone:(struct _NSZone *)zone {
    
    return [AdManager sharedInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone {
    
    return [AdManager sharedInstance] ;
}

- (AdManager*)init {
    self = [super init];
    
    if (self) {
        
        gadInterstitialNormal = [self createAndLoadInterstitial:kAdmobInterstitialId];
        
//        [self requestRewardedVideo];
    }
    
    return self;
}

- (GADInterstitial *)createAndLoadInterstitial:(NSString*)AdUintID {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:AdUintID];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"007ee895fbc5dca2f28e11feb0414433", @"45c243aa392382f9ed49a9e3617336fa", @"55d28e54f40dc98d245ad832e5c6aec897be7ac6", @"Simulator"];
    [interstitial loadRequest:request];
    return interstitial;
}

//- (void)requestRewardedVideo {
//    GADRequest *request = [GADRequest request];
//    
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
//                                           withAdUnitID:kAdmobRewardId];
//    [GADRewardBasedVideoAd sharedInstance].delegate = self;
//}

#pragma mark GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    NSLog(@"interstitialDidDismissScreen called");
    gadInterstitialNormal = [self createAndLoadInterstitial:kAdmobInterstitialId];
}


//#pragma mark GADRewardBasedVideoAdDelegate
//
//- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is received.");
//}
//
//- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Opened reward based video ad.");
//}
//
//- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad started playing.");
//}
//
//- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is closed.");
//    [self requestRewardedVideo];
//}
//
//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
//
//    NSLog(@"Reword added");
//}
//
//- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad will leave application.");
//}
//
//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
//    didFailToLoadWithError:(NSError *)error {
//    NSLog(@"Reward based video ad failed to load.");
//}
//
//- (BOOL)isRewardedVideoReady {
//    
//    if ([[GADRewardBasedVideoAd sharedInstance] isReady] ) {
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (void)presentRewardedAdFromRootViewController:(UIViewController *)viewController {
//    
//    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:viewController];
//}

- (BOOL)isInterstitialReady {
    return [gadInterstitialNormal isReady];
}

- (void)presentInterstitialAdFromRootViewController:(UIViewController *)viewController {
    
    [gadInterstitialNormal presentFromRootViewController:viewController];
}


- (void)createInterstitial {
    gadInterstitialNormal = [self createAndLoadInterstitial:kAdmobInterstitialId];
}

//- (void)createRewardedVideo {
//    [self requestRewardedVideo];
//}

@end
