//
//  NSString+ChangeColor.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/4/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NSString+ChangeColor.h"

@implementation NSString (ChangeColor)

+ (NSAttributedString *)changeColorWithContent:(NSString *)content {
    NSString *str = content;
    
    //切割
    NSArray *arr = [str componentsSeparatedByString:@"#"];
//    NSLog(@"arr=%@", arr);
    NSMutableAttributedString *sss = nil;
    
    NSUInteger len = 0;
    //循环数组里的值
    for (int i = 1; i < arr.count - 1; i++) {
        len += ((NSString*)arr[i]).length;
        len += 1;
    }
    len += 1;
    NSRange ra = NSMakeRange(0, 0);
    if (arr.count > 2) {
        ra = NSMakeRange(((NSString*)arr[0]).length, len);
    }
    sss = [[NSMutableAttributedString alloc]initWithString:str];
    
    
    [sss addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:ra];
    return sss;
}

@end
