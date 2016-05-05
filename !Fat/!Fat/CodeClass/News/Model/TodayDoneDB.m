//
//  TodayDoneDB.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "TodayDoneDB.h"
#import "TodayDoneModel.h"

#define TODAYDONTABLE @"todayDoneTable"
@implementation TodayDoneDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [FMDBManager shareInstanceWithDBName:@"TodayDone.sqlite"].dataBase;
    }
    return self;
}

// 创建表
- (void)createTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",TODAYDONTABLE];
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    } else {
        // 创建数据表
        NSString *createSql = [NSString stringWithFormat:@"create table %@ (desc text primary key)",TODAYDONTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
            // 添加默认数据
            NSArray *array = @[@"跑步", @"快走", @"健身房", @"游泳", @"瑜伽", @"羽毛球", @"单车"];
            for (int i = 0; i < array.count; i ++) {
                TodayDoneModel *model = [[TodayDoneModel alloc] init];
                model.desc = array[i];
                [self insertTodayDoneModel:model];
            }
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}

// 插入数据
- (void)insertTodayDoneModel:(TodayDoneModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(desc) values(?)",TODAYDONTABLE];
    if ([_dataBase executeUpdate:insertSql,model.desc]) {
        NSLog(@"数据插入成功");
    } else {
        NSLog(@"数据插入失败");
    }
    
}

// 查询所有数据
- (NSArray *)selectAllData {
    NSString *selectSql = [NSString stringWithFormat:@"select * from %@",TODAYDONTABLE];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        TodayDoneModel *model = [[TodayDoneModel alloc] init];
        model.desc = [set stringForColumn:@"desc"];
        [array addObject:model];
    }
    return array;
}

@end
