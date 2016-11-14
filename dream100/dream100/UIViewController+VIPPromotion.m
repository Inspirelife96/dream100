//
//  UIViewController+VIPPromotion.m
//  d3storm
//
//  Created by Chen XueFeng on 16/6/23.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+VIPPromotion.h"
#import "UIViewController+Share.h"
#import "UIViewController+IAPNotification.h"
#import "StoreManager.h"

@implementation UIViewController (VIPPromotion)

- (void) showVIPPromotion:(NSString*) title message:(NSString*) message cancelTitle:(NSString*) cancelTitle sender:(id) sender {
    
    UIAlertController *promotionAC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    if ([StoreManager sharedInstance].availableProducts.count > 0) {
        
        NSString *price = [[StoreManager sharedInstance] priceMatchingProductIdentifier:kIAPVip];
        NSString *priceMessage = [NSString stringWithFormat:@"%@购买VIP（可阅览所有谜题）", price];
        
        UIAlertAction *buyAction = [UIAlertAction
                                    actionWithTitle:priceMessage
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction *action)
                                    {
                                        [self buyVip];
                                    }];
        
        
        [promotionAC addAction:buyAction];
    }
    
    [promotionAC addAction:cancelAction];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            promotionAC.popoverPresentationController.barButtonItem = (UIBarButtonItem*)sender;
        } else {
            promotionAC.popoverPresentationController.sourceView = (UIView*)sender;
            promotionAC.popoverPresentationController.sourceRect = ((UIView*)sender).bounds;
        }
        
        [self presentViewController: promotionAC animated:YES completion:nil];
        
    } else {
        
        [self presentViewController:promotionAC animated:YES completion:nil];
    }
}

@end
