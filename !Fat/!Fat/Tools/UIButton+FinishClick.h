//
//  UIButton+FinishClick.h
//  NoFat
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//  定义一个无参无返的Block
typedef void (^FinishClickOperation)();

@interface UIButton (FinishClick)

//  声明一个Block属性
@property (nonatomic, copy)FinishClickOperation block;

@end
