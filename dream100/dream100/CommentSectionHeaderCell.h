//
//  CommentSectionHeaderCell.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/15.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentSectionHeaderCellDelegate <NSObject>

- (void)selectCommentSection:(id)sender;
- (void)selectLikeSection:(id)sender;

@end

@interface CommentSectionHeaderCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIButton *commentButton;
@property(strong, nonatomic) IBOutlet UIButton *likeButton;

@property(weak, nonatomic) id<CommentSectionHeaderCellDelegate> delegate;

- (void)setCommentButtonSelected;
- (void)setLikeButtonSelected;

- (IBAction)clickCommentButton:(id)sender;
- (IBAction)clickLikeButton:(id)sender;

@end
