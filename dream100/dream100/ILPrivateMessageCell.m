//
//  ILPrivateMessageCell.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILPrivateMessageCell.h"
#import "CDUserManager.h"
#import "UILabel+StringFrame.h"

@implementation ILPrivateMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageObject:(AVObject *)messageObject {
    if (messageObject) {
        AVUser *userObject = messageObject[@"fromUser"];
        
        [[CDUserManager manager] getAvatarImageOfUser:userObject block:^(UIImage *image) {
            _profileImageView.image = image;
        }];
        
        _messageLabel.text = messageObject[@"message"];
        _messageLabel.font = GetFontAvenirNext(14.0f);
        _messageLabel.textColor = FlatBlueDark;
        CGSize size = [_messageLabel boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 128.0f, 0.0f) attributes:nil];
        
        _messageWidthConstraint.constant = size.width;
        if (size.height < 44.0f) {
            _messageHeightConstraint.constant = 44.0f;
        } else {
            _messageHeightConstraint.constant = size.height;
        }
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%@", messageObject[@"createdAt"]];
}

+ (CGFloat)HeightForCell:(NSString *)contentString {
    UILabel *label = [[UILabel alloc] init];
    label.text = contentString;
    label.font = GetFontAvenirNext(14.0f);
    CGSize size = [label boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 128.0f, 0.0f) attributes:nil];
    
    if (size.height < 44.0f) {
        return 8.0 + 44.0f + 8.0 + 21.0 + 8.0;
    } else {
        return 8.0 + size.height + 8.0 + 21.0 + 8.0;
    }
}

@end
