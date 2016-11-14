//
//  JourneyContentView.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "JourneyContentView.h"
#import "CDUserManager.h"
#import "UILabel+StringFrame.h"
#import "HZPhotoItem.h"
#import "MyLikeCache.h"

@implementation JourneyContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setJourneyObject:(AVObject *)journeyObject {
    _journeyObject = journeyObject;
    
    AVUser *userObject = journeyObject[@"user"];
    [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
        _profileImageView.image = image;
    }];
    
    _userNameLabel.text = userObject[@"username"];
    _timeLabel.text = [NSString stringWithFormat:@"%@",journeyObject[@"createdAt"]];
    
    _journeyContentLabel.text = journeyObject[@"content"];
    _journeyContentLabel.font = GetFontAvenirNext(14.0f);
    _journeyContentLabel.textColor = FlatGray;
    CGSize size = [_journeyContentLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    _contentHeightConstraint.constant = size.height;
    
    
    _journeyPhotoGroup.photoItemArray = nil;
    NSArray *journeyImageArray = journeyObject[@"imageFiles"];
    
    if (journeyImageArray.count > 0) {
        NSMutableArray *hzPhotoItemArray = [NSMutableArray array];
        for (int i = 0; i < journeyImageArray.count; i++) {
            HZPhotoItem *item = [[HZPhotoItem alloc] init];
            item.thumbnail_pic = journeyImageArray[i];
            [hzPhotoItemArray addObject:item];
        }
        _journeyPhotoGroup.photoItemArray = [hzPhotoItemArray copy];
    }
    
    if (journeyImageArray.count <= 0) {
        _photoHeightConstraint.constant = 0.0f;
    } else if (journeyImageArray.count <= 2) {
        _photoHeightConstraint.constant = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (journeyImageArray.count <= 5) {
        _photoHeightConstraint.constant = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        _photoHeightConstraint.constant = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    BOOL isLiked = [[MyLikeCache sharedInstance] isLiked:_journeyObject[@"objectId"]];
    if (isLiked) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"button_like"] forState:UIControlStateNormal];
    } else {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"button_unlike"] forState:UIControlStateNormal];
    }
}

- (IBAction)clickLikeButton:(id)sender {
    BOOL isLiked = [[MyLikeCache sharedInstance] isLiked:_journeyObject[@"objectId"]];
    if (isLiked) {
        [_likeButton setUserInteractionEnabled:NO];
        AVQuery *query = [AVQuery queryWithClassName:@"Like"];
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
        [query whereKey:@"journey" equalTo:_journeyObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                //
            } else {
                NSInteger likeNumber = [_journeyObject[@"likeNumber"] integerValue];
                for (int i = 0; i < objects.count; i++) {
                    AVObject *likeObject = objects[i];
                    [likeObject deleteEventually];
                    likeNumber = likeNumber - 1;
                }
                
                [_journeyObject setObject:@(likeNumber) forKey:@"likeNumber"];
                [_journeyObject saveEventually];
                
                [[MyLikeCache sharedInstance] removeLike:_journeyObject[@"objectId"]];
                [_likeButton setBackgroundImage:[UIImage imageNamed:@"button_unlike"] forState:UIControlStateNormal];
            }
            [_likeButton setUserInteractionEnabled:YES];
        }];

    } else {
       
        
        [_likeButton setUserInteractionEnabled:NO];
        AVObject *likeObject = [AVObject objectWithClassName:@"Like"];
        [likeObject setObject:[AVUser currentUser] forKey:@"user"];
        [likeObject setObject:_journeyObject forKey:@"journey"];
        [likeObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                //
            } else {
                NSInteger likeNumber = [_journeyObject[@"likeNumber"] integerValue];
                [_journeyObject setObject:@(likeNumber + 1) forKey:@"likeNumber"];
                [_journeyObject saveEventually];
                
                [[MyLikeCache sharedInstance] addLike:_journeyObject[@"objectId"]];
                
                [_likeButton setBackgroundImage:[UIImage imageNamed:@"button_like"] forState:UIControlStateNormal];
            }
            [_likeButton setUserInteractionEnabled:YES];
        }];

    }
}

+ (CGFloat)HeightForJourneyContentView:(AVObject *)journeyObject {
    NSString *contentString = journeyObject[@"content"];
    NSArray *journeyImageArray = journeyObject[@"imageFiles"];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = contentString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 36.0f, 0.0f) attributes:nil];
    
    CGFloat photoHeight = 0.0f;
    
    if (journeyImageArray.count <= 0) {
        photoHeight = 0.0f;
    } else if (journeyImageArray.count <= 2) {
        photoHeight = 128.0f * 1 + 20.0f + 5.0f * 0;;
    } else if (journeyImageArray.count <= 5) {
        photoHeight = 128.0f * 2 + 20.0f + 5.0f * 1;
    } else {
        photoHeight = 128.0f * 3 + 20.0f + 5.0f * 2;
    }
    
    return 8.0f + 64.0 + size.height + photoHeight + 8.0f;
}

@end
