//
//  UserModel.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
