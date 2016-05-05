//
//  UIButton+FiniishClick.h
//  RunTime修改Button的点击事件
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishClickOperation)();

@interface UIButton (FiniishClick)

@property (nonatomic, copy) FinishClickOperation block;

@end
