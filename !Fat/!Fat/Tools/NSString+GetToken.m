//
//  NSString+GetToken.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "NSString+GetToken.h"

@implementation NSString (GetToken)

+ (NSString *)GetURLEncodeWithUserToken {
    NSString * token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    NSString *urlString = [ALTERUSERINFOURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
    return urlString;
}

@end
