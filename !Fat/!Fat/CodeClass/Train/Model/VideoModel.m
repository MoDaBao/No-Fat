//
//  VideoModel.m
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.videoID = value;
    }
}

- (NSString *)photo {
    NSArray *array = [_photo componentsSeparatedByString:@"/"];
    return [NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640",array[0], array[1]];
}

- (UIImage *)difficultyImg {
    if ([_difficulty isEqualToNumber:@(1)]) {
        return [UIImage imageNamed:@"yikeBlack"];
    } else if ([_difficulty isEqualToNumber:@(2)]) {
        return [UIImage imageNamed:@"liangkeBlack"];
    } else {
        return [UIImage imageNamed:@"sankeBlack"];
    }
}

@end
