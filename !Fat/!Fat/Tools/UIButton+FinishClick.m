//
//  UIButton+FinishClick.m
//  NoFat
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "UIButton+FinishClick.h"
#import <objc/runtime.h>//  引入runtime框架

static const char *UIButtonClick;

@implementation UIButton (FinishClick)

//  重写setter 和 getter 方法
- (void)setBlock:(FinishClickOperation)block {
    //  获取系统内部的setter方法
    objc_setAssociatedObject(self, &UIButtonClick, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    //  拦截target方法 变成 自己的方法
    [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (FinishClickOperation)block {
    return objc_getAssociatedObject(self, &UIButtonClick);
}

//  按钮点击触发的方法
- (void)click:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
