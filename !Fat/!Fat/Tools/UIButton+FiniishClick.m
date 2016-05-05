//
//  UIButton+FiniishClick.m
//  RunTime修改Button的点击事件
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "UIButton+FiniishClick.h"
#import <objc/runtime.h>
static const char *UIButtonClick;
@implementation UIButton (FiniishClick)


- (void)setBlock:(FinishClickOperation)block {
    
    //第一个参数是自己 第二个是地址 第三个是自己传入的block
    objc_setAssociatedObject(self, &UIButtonClick, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (FinishClickOperation)block {
    return objc_getAssociatedObject(self, &UIButtonClick);
}

- (void)click {
    if (self.block) {
        
         self.block();
    }
  
}

@end
