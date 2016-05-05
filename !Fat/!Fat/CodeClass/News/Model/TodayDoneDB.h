//
//  TodayDoneDB.h
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodayDoneModel.h"

@interface TodayDoneDB : NSObject

// 数据库操作对象
@property (nonatomic, strong) FMDatabase *dataBase;

// 创建表
- (void)createTable;

// 插入数据
- (void)insertTodayDoneModel:(TodayDoneModel *)model;

// 查询所有数据
- (NSArray *)selectAllData;

@end
