//
//  UIViewController+DreamAction.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/27.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "UIViewController+DreamAction.h"
#import "JMImagesActionSheet.h"
#import "JMCollectionItem.h"
#import "MyDreamCache.h"
#import "XWPublishController.h"
#import "ILDreamDBManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import "UIViewController+Share.h"
#import "UIView+TYAlertView.h"

@implementation UIViewController (DreamAction)

- (void)showActionForDream:(AVObject *)dreamObject onView:(UIView *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"更多操作" message:nil];
    
    if ([[MyDreamCache sharedInstance] isMyDream:dreamObject[@"objectId"]]) {
        [alertView addAction:[TYAlertAction actionWithTitle:@"心路历程" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            XWPublishController *journeyPublishVC = [[XWPublishController alloc] init];
            journeyPublishVC.type = 1;
            journeyPublishVC.dreamObject = dreamObject;
            [self.navigationController pushViewController:journeyPublishVC animated:YES];
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"梦想签到" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager addStandardJourney:ILJourneyTypeDailyCheck toDream:dreamObject];
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"美梦如愿" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager addStandardJourney:ILJourneyTypeDone toDream:dreamObject];
        }]];
        
        [alertView addAction:[TYAlertAction actionWithTitle:@"放弃梦想" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager removeDream:dreamObject];
        }]];
    } else {
        [alertView addAction:[TYAlertAction actionWithTitle:@"许下梦想" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager joinDream:dreamObject];
        }]];
    }
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"分享" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        NSString *categoryString = dreamObject[@"category"];
        NSString *dreamString = dreamObject[@"content"];
        NSString *sharedString = [NSString stringWithFormat:@"%@:\n%@", categoryString, dreamString];
        [self shareMessage:sharedString onView:sender];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"举报" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
         [self tipoffs:sender forDream:dreamObject];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];

//    
//    
//    
//    
//    JMActionSheetDescription *description = [[JMActionSheetDescription alloc] init];
//    description.actionSheetTintColor = [UIColor grayColor];
//    description.actionSheetCancelButtonFont = GetFontAvenirNext(17.0f);
//    description.actionSheetOtherButtonFont = GetFontAvenirNext(16.0f);
//    description.title = @"更多操作";
//    
//    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
//    cancelItem.title = @"取消";
//    description.cancelItem = cancelItem;
//    
//    JMActionSheetCollectionItem *operationCollection = [[JMActionSheetCollectionItem alloc] init];
//    NSMutableArray *operationItems = [[NSMutableArray alloc] init];
//    JMCollectionItem *itemShare = [[JMCollectionItem alloc] init];
//    itemShare.actionName = @"分享";
//    itemShare.actionImage = [UIImage imageNamed:@"icon_dream_share"];
//    [operationItems addObject:itemShare];
//    
//    JMCollectionItem *itemTipoffs = [[JMCollectionItem alloc] init];
//    itemTipoffs.actionName = @"举报";
//    itemTipoffs.actionImage = [UIImage imageNamed:@"icon_dream_tipoffs"];
//    [operationItems addObject:itemTipoffs];
//    
//    operationCollection.elements = (NSArray <JMActionSheetCollectionItem> *)operationItems;
//    operationCollection.collectionActionBlock = ^(JMCollectionItem *selectedValue){
//        if ([selectedValue.actionName isEqualToString:@"分享"]) {
//            NSString *categoryString = dreamObject[@"category"];
//            NSString *dreamString = dreamObject[@"content"];
//            NSString *sharedString = [NSString stringWithFormat:@"%@:\n%@", categoryString, dreamString];
//            [self shareMessage:sharedString onView:sender];
//        } else {
//            [self tipoffs:sender forDream:dreamObject];
//        }
//    };
//    
//    JMActionSheetCollectionItem *dreamActionCollection = [[JMActionSheetCollectionItem alloc] init];
//    NSMutableArray *dreamActionItems = [[NSMutableArray alloc] init];
//    
//    if ([[MyDreamCache sharedInstance] isMyDream:dreamObject[@"objectId"]]) {
//        JMCollectionItem *itemJourney = [[JMCollectionItem alloc] init];
//        itemJourney.actionName = @"心路历程";
//        itemJourney.actionImage = [UIImage imageNamed:@"icon_dream_journey"];
//        [dreamActionItems addObject:itemJourney];
//        
//        JMCollectionItem *itemSign = [[JMCollectionItem alloc] init];
//        itemSign.actionName = @"梦想签到";
//        itemSign.actionImage = [UIImage imageNamed:@"icon_dream_dailycheck"];
//        [dreamActionItems addObject:itemSign];
//        
////        JMCollectionItem *itemAnswer = [[JMCollectionItem alloc] init];
////        itemAnswer.actionName = @"梦想解答";
////        itemAnswer.actionImage = [UIImage imageNamed:@"Icon-share"];
////        [dreamActionItems addObject:itemAnswer];
//        
//        JMCollectionItem *itemDone = [[JMCollectionItem alloc] init];
//        itemDone.actionName = @"美梦如愿";
//        itemDone.actionImage = [UIImage imageNamed:@"icon_dream_achieve"];
//        [dreamActionItems addObject:itemDone];
//        
//        JMCollectionItem *itemQuit = [[JMCollectionItem alloc] init];
//        itemQuit.actionName = @"放弃梦想";
//        itemQuit.actionImage = [UIImage imageNamed:@"icon_dream_giveup"];
//        [dreamActionItems addObject:itemQuit];
//    } else {
//        JMCollectionItem *itemJoin = [[JMCollectionItem alloc] init];
//        itemJoin.actionName = @"许下梦想";
//        itemJoin.actionImage = [UIImage imageNamed:@"icon_dream_join"];
//        [dreamActionItems addObject:itemJoin];
//    }
//    
//    dreamActionCollection.elements = (NSArray <JMActionSheetCollectionItem> *)dreamActionItems;
//    dreamActionCollection.collectionActionBlock = ^(JMCollectionItem *selectedValue){
//        if ([selectedValue.actionName isEqualToString:@"许下梦想"]) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [ILDreamDBManager joinDream:dreamObject];
//        } else if ([selectedValue.actionName isEqualToString:@"放弃梦想"]) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [ILDreamDBManager removeDream:dreamObject];
//        } else if ([selectedValue.actionName isEqualToString:@"心路历程"]) {
//            XWPublishController *journeyPublishVC = [[XWPublishController alloc] init];
//            journeyPublishVC.type = 1;
//            journeyPublishVC.dreamObject = dreamObject;
//            [self.navigationController pushViewController:journeyPublishVC animated:YES];
//        } else if ([selectedValue.actionName isEqualToString:@"梦想签到"]) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [ILDreamDBManager addStandardJourney:ILJourneyTypeDailyCheck toDream:dreamObject];
////        } else if ([selectedValue.actionName isEqualToString:@"梦想解答"]) {
////            //
//        } else if ([selectedValue.actionName isEqualToString:@"美梦如愿"]) {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [ILDreamDBManager addStandardJourney:ILJourneyTypeDone toDream:dreamObject];
//        } else {
//            //
//        }
//    };
//    
//    description.items = @[operationCollection, dreamActionCollection];
//    [JMActionSheet showActionSheetDescription:description inViewController:self.tabBarController fromView:sender permittedArrowDirections:UIPopoverArrowDirectionAny];
}

- (void)tipoffs:(UIView *)sender forDream:(AVObject *)dreamObject {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"请选择举报的原因" message:nil];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"色情低俗" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self submitTipoffs:@"色情低俗" forDream:dreamObject];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"广告，谣言，政治敏感" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self submitTipoffs:@"广告，谣言，政治敏感" forDream:dreamObject];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"主题不相关" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self submitTipoffs:@"主题不相关" forDream:dreamObject];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"其它" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self submitTipoffs:@"其它" forDream:dreamObject];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)submitTipoffs:(NSString *)tipoffsString forDream:(AVObject *)dreamObject {
    AVObject *object = [AVObject objectWithClassName:@"Tipoffs"];
    [object setObject:[AVUser currentUser] forKey:@"user"];
    [object setObject:dreamObject forKey:@"dream"];
    
    [object saveEventually];
}

@end
