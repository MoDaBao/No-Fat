//
//  ProgramModel.m
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "ProgramModel.h"

@implementation ProgramModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.programID = value;
    }
}

//  重写getter方法
- (NSString *)photo {
    // 拼接图片URL http://ft-video.fit-time.cn/program_4.png@!640
    NSArray *array = [_photo componentsSeparatedByString:@"/"];
    NSString *photoUrl = [NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640",array[0], array[1]];
    return photoUrl;
}

- (NSString *)coachPhoto {
    // 拼接图片URL http://ft-video.fit-time.cn/coach_4.jpg@!640
    NSArray *array = [_photo componentsSeparatedByString:@"/"];
    NSString *photoUrl = [NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640",array[0], array[1]];
    return photoUrl;
}

//  获取coachName字符串的宽度
- (CGFloat)getHeightOfCoachName {
    
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, MAXFLOAT);
    return [_coachName boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
}

- (UIImage *)difficultyImg {
    if ([_difficulty isEqualToNumber:@(1)]) {
        return [UIImage imageNamed:@"yike"];
    } else if ([_difficulty isEqualToNumber:@(2)]) {
        return [UIImage imageNamed:@"liangke"];
    } else {
        return [UIImage imageNamed:@"sanke"];
    }
}

@end











