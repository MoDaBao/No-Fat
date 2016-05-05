//
//  RecommendDetailModel.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendDetailModel.h"

@implementation RecommendDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
- (CGFloat)textHeight
{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
    CGFloat textH = [self.comment boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    //计算
    return textH;
}

@end
