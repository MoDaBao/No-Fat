//
//  ChangeColorManager.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeColorManager : NSObject

//  通过颜色名改变颜色
+ (void)changColorWithImageView:(UIImageView *)imageView color:(NSString *)color;
//
+ (NSString *)changColorNameWithColor:(NSString *)color;
/**  通过颜色字符串获取颜色对象*/
+ (UIColor *)getColorWithColorString:(NSString *)colorString;

@end
