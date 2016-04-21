//
//  FMDBManager.h
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//
//  数据库管理类

#import <Foundation/Foundation.h>

@interface FMDBManager : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;// 数据库操作对象

//  单例方法
+ (FMDBManager *)shareInstanceWithDBName:(NSString *)name;

//  初始化方法
- (instancetype)initWithDBName:(NSString *)name;

@end
