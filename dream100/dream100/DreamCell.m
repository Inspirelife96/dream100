//
//  DreamCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/5.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "DreamCell.h"
#import "HZPhotoItem.h"
#import "UILabel+StringFrame.h"
#import "MyDreamCache.h"

@implementation DreamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDreamObject:(AVObject *)dreamObject {
    _dreamObject = dreamObject;
    
    _contentLabel.text = dreamObject[@"content"];
    _contentLabel.font = GetFontAvenirNext(14.0f);
    _contentLabel.textColor = FlatGray;
    CGSize size = [_contentLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    _contentHeightConstraint.constant = size.height;

    _photoGroup.photoItemArray = nil;
    NSArray *dreamImageArray = dreamObject[@"imageFiles"];
    if (dreamImageArray.count > 0) {
        NSMutableArray *hzPhotoItemArray = [NSMutableArray array];
        for (int i = 0; i < dreamImageArray.count; i++) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init]; 
            item.thumbnail_pic = dreamImageArray[i];
            [hzPhotoItemArray addObject:item];
        }
        _photoGroup.photoItemArray = [hzPhotoItemArray copy];
    }
        
    if (dreamImageArray.count <= 0) {
        _photoHeightConstraint.constant = 0.0f;
    } else if (dreamImageArray.count <= 2) {
        _photoHeightConstraint.constant = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (dreamImageArray.count <= 5) {
        _photoHeightConstraint.constant = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        _photoHeightConstraint.constant = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    NSString *categoryString = @"标签:#未设置#";
    
    if (dreamObject[@"category"] != nil && ![dreamObject[@"category"] isEqualToString:@""]) {
        categoryString = [NSString stringWithFormat:@"标签:%@", dreamObject[@"category"]];
    }
    
    [_categoryButton setTitle:categoryString forState:UIControlStateNormal];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", dreamObject[@"createdAt"]];
    
    BOOL isMyDream = [[MyDreamCache sharedInstance] isMyDream:dreamObject[@"objectId"]];
    if (isMyDream) {
        [_addToMyDreamButton setUserInteractionEnabled:NO];
        
        NSString *dreamStatus = [[MyDreamCache sharedInstance] getDreamStatus:dreamObject[@"objectId"]];
        if([dreamStatus isEqualToString:@"完成"]) {
            [_addToMyDreamButton setBackgroundImage:[UIImage imageNamed:@"button_done"] forState:UIControlStateNormal];
        } else {
            [_addToMyDreamButton setBackgroundImage:[UIImage imageNamed:@"button_progress"] forState:UIControlStateNormal];
        }
    } else {
            [_addToMyDreamButton setUserInteractionEnabled:YES];
            [_addToMyDreamButton setBackgroundImage:[UIImage imageNamed:@"button_join"] forState:UIControlStateNormal];
    }
    
    _dreamStatusLabel.text = [NSString stringWithFormat:@"共梦者(%ld) ｜ 心路历程(%ld)", (long)[_dreamObject[@"followers"] integerValue], (long)[_dreamObject[@"journeys"] integerValue]];
}

+ (CGFloat)HeightForDreamCell:(AVObject *)dreamObject {
    NSString *dreamString = dreamObject[@"content"];
    NSArray *dreamImageArray = dreamObject[@"imageFiles"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = dreamString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    
    CGFloat photoHeight = 0.0f;
    
    if (dreamImageArray.count <= 0) {
        photoHeight = 0.0f;
    } else if (dreamImageArray.count <= 2) {
        photoHeight = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (dreamImageArray.count <= 5) {
        photoHeight = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        photoHeight = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    return 8.0f + 44.0 + size.height + photoHeight + 39.0f + 8.0f;
}

- (IBAction)clickAddToMyDreamButton:(id)sender {
    BOOL isMyDream = [[MyDreamCache sharedInstance] isMyDream:_dreamObject[@"objectId"]];
    if (isMyDream) {
        AVQuery *query = [AVQuery queryWithClassName:@"DreamFollow"];
        [query whereKey:@"dream" equalTo:_dreamObject];
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                //
            } else {
                for (int i = 0; i < objects.count; i++) {
                    [objects[i] deleteEventually];
                }
            }
        }];

        [[MyDreamCache sharedInstance] removeDream:_dreamObject[@"objectId"]];
        
        [_addToMyDreamButton setBackgroundImage:[UIImage imageNamed:@"button_join"] forState:UIControlStateNormal];
        [_addToMyDreamButton setUserInteractionEnabled:YES];
    } else {
        AVObject *dreamFollowObject = [AVObject objectWithClassName:@"DreamFollow"];
        [dreamFollowObject setObject:_dreamObject forKey:@"dream"];
        [dreamFollowObject setObject:[AVUser currentUser] forKey:@"user"];
        [dreamFollowObject setObject:@"追梦" forKey:@"status"];
        [dreamFollowObject saveEventually];
        
        NSInteger followNumber = [_dreamObject[@"followers"] integerValue];
        [_dreamObject setObject:@(followNumber + 1) forKey:@"followers"];
        [_dreamObject saveEventually];
        
        AVQuery *query = [AVQuery queryWithClassName:@"DreamCount"];
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                //
            } else {
                if (objects.count > 0) {
                    AVObject *object = objects[0];
                    NSInteger count = [object[@"dreamCount"] integerValue];
                    [object setObject:@(count + 1) forKey:@"dreamCount"];
                    [object saveEventually];
                }
            }
        }];
        
        [[MyDreamCache sharedInstance] addDream:_dreamObject[@"objectId"]];
        [_addToMyDreamButton setBackgroundImage:[UIImage imageNamed:@"button_progress"] forState:UIControlStateNormal];
        [_addToMyDreamButton setUserInteractionEnabled:YES];
    }
    
    if ([_delegate respondsToSelector:@selector(joinDream:)]) {
        [_delegate joinDream:sender];
    }
}

@end
