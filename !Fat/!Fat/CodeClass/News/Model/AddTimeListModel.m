//
//  AddTimeListModel.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddTimeListModel.h"

@implementation AddTimeListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
- (CGFloat)textHeight
{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
    CGFloat textH = [self.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    //计算
    return textH;
}

@end
