//
//  ProgramDailyListModel.m
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "ProgramDailyListModel.h"

@implementation ProgramDailyListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.dailyID = value;
    }
}

@end
