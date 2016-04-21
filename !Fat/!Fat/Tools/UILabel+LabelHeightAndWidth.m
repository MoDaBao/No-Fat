//
//  UILabel+LabelHeightAndWidth.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UILabel+LabelHeightAndWidth.h"

@implementation UILabel (LabelHeightAndWidth)

//  根据宽度获取高度
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label.frame.size.height;
}

//  根据文字获取宽度
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
