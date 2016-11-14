//
//  UIViewController+IAPNotification.m
//  IOSSkillTree
//
//  Created by Chen XueFeng on 16/6/7.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+IAPNotification.h"
#import "UIViewController+Alert.h"

#import <StoreKit/StoreKit.h>
#import "StoreManager.h"
#import "StoreObserver.h"
#import "MBProgressHUD.h"

@implementation UIViewController (IAPNotification)

- (void)addIAPNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleProductRequestNotification:)
                                                 name:IAPProductRequestNotification
                                               object:[StoreManager sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesCancelNotification:)
                                                 name:IAPPurchaseCancelNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRestoreCancelNotification:)
                                                 name:IAPRestoreCancelNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRestoreCompleteNotification:)
                                                 name:IAPRestoreCompleteNotification
                                               object:[StoreObserver sharedInstance]];
}

- (void)removeIAPNotification {
    // Unregister for StoreManager's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPProductRequestNotification
                                                  object:[StoreManager sharedInstance]];
    
    // Unregister for StoreObserver's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPPurchaseNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPPurchaseCancelNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPRestoreCancelNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPRestoreCompleteNotification
                                                  object:[StoreObserver sharedInstance]];
}


- (void)buyVip {
    SKProduct *product = [[StoreManager sharedInstance] getProductByIdentifier:kIAPVip];
    
    if (product) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[StoreObserver sharedInstance] buy:product];
    }
}

// Update the UI according to the product request notification result
-(void)handleProductRequestNotification:(NSNotification *)notification {
    StoreManager *productRequestNotification = (StoreManager*)notification.object;
    IAPProductRequestStatus result = (IAPProductRequestStatus)productRequestNotification.status;
    
    if (result == IAPProductRequestResponse) {
    }
}

- (void)handlePurchasesNotification:(NSNotification *)notification {
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    
    switch (status) {
        case IAPPurchaseFailed:
            [self presentAlertTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
        case IAPRestoredSucceeded:
            break;
        case IAPRestoredFailed:
            [self presentAlertTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
        case IAPDownloadStarted:
            break;
        case IAPDownloadInProgress:
            break;
        case IAPDownloadSucceeded:
            break;
        default:
            break;
    }
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPAdRemoved]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsAdRemoved];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsVip];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVIPChanged object:nil];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)handlePurchasesCancelNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)handleRestoreCompleteNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPAdRemoved]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPAdRemoved];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPVip];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVIPChanged object:nil];
    }
}

-(void)handleRestoreCancelNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
