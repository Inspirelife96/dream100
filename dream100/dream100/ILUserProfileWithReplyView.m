//
//  ILUserProfileWithReplyView.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/9.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILUserProfileWithReplyView.h"

@implementation ILUserProfileWithReplyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCommentObject:(AVObject *)commentObject {
    _commentObject = commentObject;
    self.userProfileDevaultView.delegate = (id<ILUserProfileDefaultViewDelegate>)self.delegate;
    self.userProfileDevaultView.userObject = commentObject[@"fromUser"];
}

- (IBAction)clickReplyButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickReply:)]) {
        [self.delegate clickReply:_commentObject];
    }
}

@end
