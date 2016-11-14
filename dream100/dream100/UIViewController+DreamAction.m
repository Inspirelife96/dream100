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

@implementation UIViewController (DreamAction)

- (void)showActionForDream:(AVObject *)dreamObject onView:(UIView *)sender {
    JMActionSheetDescription *description = [[JMActionSheetDescription alloc] init];
    description.actionSheetTintColor = [UIColor grayColor];
    description.actionSheetCancelButtonFont = GetFontAvenirNext(17.0f);
    description.actionSheetOtherButtonFont = GetFontAvenirNext(16.0f);
    description.title = @"更多操作";
    
    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
    cancelItem.title = @"取消";
    description.cancelItem = cancelItem;
    
    JMActionSheetCollectionItem *operationCollection = [[JMActionSheetCollectionItem alloc] init];
    NSMutableArray *operationItems = [[NSMutableArray alloc] init];
    JMCollectionItem *itemShare = [[JMCollectionItem alloc] init];
    itemShare.actionName = @"分享";
    itemShare.actionImage = [UIImage imageNamed:@"Icon-share"];
    [operationItems addObject:itemShare];
    
    JMCollectionItem *itemTipoffs = [[JMCollectionItem alloc] init];
    itemTipoffs.actionName = @"举报";
    itemTipoffs.actionImage = [UIImage imageNamed:@"Icon-share"];
    [operationItems addObject:itemTipoffs];
    
    operationCollection.elements = (NSArray <JMActionSheetCollectionItem> *)operationItems;
    operationCollection.collectionActionBlock = ^(JMCollectionItem *selectedValue){
        if ([selectedValue.actionName isEqualToString:@"分享"]) {
            NSString *categoryString = dreamObject[@"category"];
            NSString *dreamString = dreamObject[@"content"];
            NSString *sharedString = [NSString stringWithFormat:@"%@:\n%@", categoryString, dreamString];
            [self shareMessage:sharedString onView:sender];
        } else {
            //[self tipoffs:sender];
        }
    };
    
    JMActionSheetCollectionItem *dreamActionCollection = [[JMActionSheetCollectionItem alloc] init];
    NSMutableArray *dreamActionItems = [[NSMutableArray alloc] init];
    
    if ([[MyDreamCache sharedInstance] isMyDream:dreamObject[@"objectId"]]) {
        JMCollectionItem *itemJourney = [[JMCollectionItem alloc] init];
        itemJourney.actionName = @"心路历程";
        itemJourney.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemJourney];
        
        JMCollectionItem *itemSign = [[JMCollectionItem alloc] init];
        itemSign.actionName = @"梦想签到";
        itemSign.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemSign];
        
        JMCollectionItem *itemAnswer = [[JMCollectionItem alloc] init];
        itemAnswer.actionName = @"梦想解答";
        itemAnswer.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemAnswer];
        
        JMCollectionItem *itemDone = [[JMCollectionItem alloc] init];
        itemDone.actionName = @"美梦如愿";
        itemDone.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemDone];
        
        JMCollectionItem *itemQuit = [[JMCollectionItem alloc] init];
        itemQuit.actionName = @"放弃梦想";
        itemQuit.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemQuit];
    } else {
        JMCollectionItem *itemJoin = [[JMCollectionItem alloc] init];
        itemJoin.actionName = @"许下梦想";
        itemJoin.actionImage = [UIImage imageNamed:@"Icon-share"];
        [dreamActionItems addObject:itemJoin];
    }
    
    dreamActionCollection.elements = (NSArray <JMActionSheetCollectionItem> *)dreamActionItems;
    dreamActionCollection.collectionActionBlock = ^(JMCollectionItem *selectedValue){
        if ([selectedValue.actionName isEqualToString:@"许下梦想"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager joinDream:dreamObject];
        } else if ([selectedValue.actionName isEqualToString:@"放弃梦想"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager removeDream:dreamObject];
        } else if ([selectedValue.actionName isEqualToString:@"心路历程"]) {
            XWPublishController *journeyPublishVC = [[XWPublishController alloc] init];
            journeyPublishVC.type = 1;
            journeyPublishVC.dreamObject = dreamObject;
            [self.navigationController pushViewController:journeyPublishVC animated:YES];
        } else if ([selectedValue.actionName isEqualToString:@"梦想签到"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager addStandardJourney:ILJourneyTypeDailyCheck toDream:dreamObject];
        } else if ([selectedValue.actionName isEqualToString:@"梦想解答"]) {
            //
        } else if ([selectedValue.actionName isEqualToString:@"美梦如愿"]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ILDreamDBManager addStandardJourney:ILJourneyTypeDone toDream:dreamObject];
        } else {
            //
        }
    };
    
    description.items = @[operationCollection, dreamActionCollection];
    [JMActionSheet showActionSheetDescription:description inViewController:self.tabBarController fromView:sender permittedArrowDirections:UIPopoverArrowDirectionAny];
}

- (void)tipoffs:(UIView *)sender {
    
}

@end
