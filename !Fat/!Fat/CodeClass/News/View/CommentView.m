//
//  CommentView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "CommentView.h"
#import "UIControlFlagView.h"
#import "KeyBoardView.h"


@implementation CommentView

+ (instancetype)commentView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
 
    [self.commentBT addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.praiseBT addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBT addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(UIButton *)sender {
    if (sender == self.commentBT) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickButton:)]) {
            [self.delegate clickButton:self.commentBT];

    }
    }else if (sender == self.praiseBT) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickButton:)]) {
            [self.delegate clickButton:self.praiseBT];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickButton:)]) {
            [self.delegate clickButton:self.shareBT];
        }
    }
}






@end
