//
//  ButtonView.m
//  No! Fat
//
//  Created by hu胡洁佩 on 16/4/19.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "ButtonView.h"
@interface ButtonView()

@end
@implementation ButtonView
+ (instancetype)buttonView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ButtonView" owner:nil options:nil]lastObject];
}
- (void)awakeFromNib
{
    [self.tuijian addTarget:self action:@selector(clickTuijian:) forControlEvents:UIControlEventTouchUpInside];
    [self.guanzhu addTarget:self action:@selector(clickTuijian:) forControlEvents:UIControlEventTouchUpInside];
    [self.zuixin addTarget:self action:@selector(clickTuijian:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)clickTuijian:(UIButton *)sender
{
    if (sender == self.tuijian) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(didClickButton:)]) {
            [self.delegete didClickButton:self.tuijian];
        }
    }else if (sender == self.guanzhu)
    {
        if (self.delegete && [self.delegete respondsToSelector:@selector(didClickButton:)]) {
            [self.delegete didClickButton:self.guanzhu];
        }
    }else if (sender == self.zuixin) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(didClickButton:)]) {
            [self.delegete didClickButton:self.zuixin];
        }
    }
}
@end
