//
//  NetWorkRequestManager.m
//  Leisure
//
//  Created by hu胡洁佩 on 16/3/29.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "NetWorkRequestManager.h"

@implementation NetWorkRequestManager


+ (void)requestWithType:(RequestType)type url:(NSString *)urlString dic:(NSDictionary *)dic finish:(RequestFinish)finish error:(RequestError)error1 {
    
    NetWorkRequestManager *manager = [[NetWorkRequestManager alloc] init];
    [manager requestWithType:type url:urlString dic:dic finish:finish error:error1];
    
}

- (void)requestWithType:(RequestType)type url:(NSString *)urlString dic:(NSDictionary *)dic finish:(RequestFinish)finish error:(RequestError)error1 {
     //拿到参数之后进行请求
    NSURL *url = [NSURL URLWithString:urlString];
    //创建可变的URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
     //如果请求方式是POST需要设置参数和请求方式
    if (type == POST) {
    [request setHTTPMethod:@"POST"];
    if (dic.count > 0) {
        NSData *data = [self getDataToDic:dic];
        //设置请求参数的Body体
        [request setHTTPBody:data];
    }
}
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            finish(data);
        } else {
            error1(error);
        }
    }];
    
    [task resume];
}

//把参数字典转为POST请求所需要的参数体
- (NSData *)getDataToDic:(NSDictionary *)dic {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in dic) {
         //遍历字典得到每一个键，得到所有的 Key＝Value类型的字符串
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, dic[key]];
        [array addObject:str];
    }
    //数组里所有Key＝Value的字符串通过&符号连接
    NSString *data = [array componentsJoinedByString:@"&"];
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}



@end
