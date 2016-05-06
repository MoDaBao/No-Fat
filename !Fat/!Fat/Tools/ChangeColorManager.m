//
//  ChangeColorManager.m
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ChangeColorManager.h"

@implementation ChangeColorManager

//  通过颜色名改变颜色
+ (void)changColorWithImageView:(UIImageView *)imageView color:(NSString *)color {
    if ([color isEqualToString:@"kPink"]) {
        imageView.backgroundColor = kPink;
    } else if ([color isEqualToString:@"kGray"]) {
        imageView.backgroundColor = kGray;
    } else if ([color isEqualToString:@"kGreen"]) {
        imageView.backgroundColor = kGreen;
    } else if ([color isEqualToString:@"kBlue"]) {
        imageView.backgroundColor = kBlue;
    }
}
//
+ (NSString *)changColorNameWithColor:(NSString *)color {
    if ([color isEqualToString:@"kPink"]) {
        return @"粉色";
    } else if ([color isEqualToString:@"kGray"]) {
        return @"灰色";
    } else if ([color isEqualToString:@"kGreen"]) {
        return @"绿色";
    } else if ([color isEqualToString:@"kBlue"]) {
        return @"蓝色";
    }
    return nil;
}


@end
