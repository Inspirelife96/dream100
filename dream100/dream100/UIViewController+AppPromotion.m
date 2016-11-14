//
//  UIViewController+AppPromotion.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+AppPromotion.h"
#import "TAPromotee/TAPromotee.h"
#import "AdManager.h"

NSString *const kPromotionWowStorm = @"wowstorm://";
NSString *const kPromotionD3Storm = @"d3storm://";
NSString *const kPromotionSCStorm = @"starcraftstorm://";
NSString *const kPromotionOWStorm = @"owstorm://";
NSString *const kPromotionHSStorm = @"hsstorm://";
NSString *const kPromotionHeroesStorm = @"heroesstorm://";

NSString *const kPromotionWowStormID = @"1086303564";
NSString *const kPromotionD3StormID = @"1125770301";
NSString *const kPromotionSCStormID = @"1130826514";
NSString *const kPromotionOWStormID = @"1133026944";
NSString *const kPromotionHSStormID = @"1134834492";
NSString *const kPromotionHeroesStormID = @"1141179825";


@implementation UIViewController (AppPromotion)

- (void)promotion {
    NSInteger randomValue = arc4random()%15;
    NSNumber *appId = [self getPromationAppInfo];
    
    if (randomValue == 9) {
        if (appId) {
            [self promotionApp:appId];
        } else {
            if ([[AdManager sharedInstance] isInterstitialReady]) {
                [[AdManager sharedInstance] presentInterstitialAdFromRootViewController:self.navigationController];
            } else {
                [[AdManager sharedInstance] createInterstitial];
            }
        }
    } else if (randomValue == 8) {
        if ([[AdManager sharedInstance] isInterstitialReady]) {
            [[AdManager sharedInstance] presentInterstitialAdFromRootViewController:self.navigationController];
        } else {
            [[AdManager sharedInstance] createInterstitial];
            if (appId) {
                [self promotionApp:appId];
            }
        }
    }
}

- (void)promotionApp:(NSNumber *)appId {
    [TAPromotee showFromViewController:self.navigationController
                                 appId:[appId integerValue]
                               caption:@""
                            completion:^(TAPromoteeUserAction userAction) {
                                switch (userAction) {
                                    case TAPromoteeUserActionDidClose:
                                        // The user just closed the add
                                        break;
                                    case TAPromoteeUserActionDidInstall:
                                        // The user did click on the Install button so here you can for example disable the ad for the future
                                        break;
                                }
                            }];
}

- (NSNumber *)getPromationAppInfo {
    NSMutableArray *promotionArray = [[NSMutableArray alloc] initWithCapacity:6];

    NSArray *appArray = @[kPromotionWowStorm,
                          kPromotionD3Storm,
                          kPromotionSCStorm,
                          kPromotionOWStorm,
                          kPromotionHSStorm,
                          kPromotionHeroesStorm];
    
    NSArray *appIDArray = @[kPromotionWowStormID,
                          kPromotionD3StormID,
                          kPromotionSCStormID,
                          kPromotionOWStormID,
                          kPromotionHSStormID,
                          kPromotionHeroesStormID];

    for (int i = 0; i < appArray.count; i++) {
        if (![self isAppInstalled:appArray[i]]) {
            [promotionArray addObject:appIDArray[i]];
        }
    }
    
    if (promotionArray.count == 0) {
        return nil;
    } else {
        NSInteger randomIndex = arc4random()%promotionArray.count;
        return promotionArray[randomIndex];
    }
}

- (BOOL)isAppInstalled:(NSString*)appNameString {
    NSURL* appUrl = [NSURL URLWithString:appNameString];
    if ([[UIApplication sharedApplication] canOpenURL:appUrl]) {
        return YES;
    }
    
    return NO;
}

@end
