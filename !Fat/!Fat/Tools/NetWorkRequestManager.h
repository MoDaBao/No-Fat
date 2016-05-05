//
//  NetWorkRequestManager.h
//  Leisure
//
//  Created by hu胡洁佩 on 16/3/29.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <Foundation/Foundation.h>


//  定义枚举 用来标识请求的类型
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

//网络请求成功的block
typedef void (^RequestFinish)(NSData *data);
//失败的block
typedef void (^RequestError)(NSError *error);

@interface NetWorkRequestManager : NSObject

+ (void)requestWithType:(RequestType)type url:(NSString *)urlString dic:(NSDictionary *)dic finish:(RequestFinish)finish error:(RequestError)error1;


@end
