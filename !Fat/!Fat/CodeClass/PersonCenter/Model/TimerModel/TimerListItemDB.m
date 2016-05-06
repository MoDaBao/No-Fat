//
//  TimerListItemDB.m
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerListItemDB.h"

@implementation TimerListItemDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [FMDBManager shareInstanceWithDBName:DATABASENAME].dataBase;
    }
    return self;
}

//  创建表
- (void)createTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",TIMERLISTITEMTABLE];
    // 查询数据表中元素个数
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已存在");
    } else {
        // 创建数据表
        NSString *createSql = [NSString stringWithFormat:@"create table %@ (title text primary key, icon text, iconBGColor text, desc text)",TIMERLISTITEMTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}

//  插入数据
- (void)insertTimerListItemModel:(TimerListItemModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (icon, iconBGColor, title, desc) values(?, ?, ?, ?)",TIMERLISTITEMTABLE];
    // 创建插入内容
    NSMutableArray *contentArray = [NSMutableArray array];
    if (model.icon) {
        [contentArray addObject:model.icon];
    }
    if (model.iconBGColor) {
        [contentArray addObject:model.iconBGColor];
    }
    if (model.title) {
        [contentArray addObject:model.title];
    }
    if (model.desc) {
        [contentArray addObject:model.desc];
    }
    if ([_dataBase executeUpdate:insertSql withArgumentsInArray:contentArray]) {
        NSLog(@"插入成功");
    } else {
        NSLog(@"插入失败");
    }
    
}

//  删除数据
- (void)deleteWithTitle:(NSString *)title {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where title = '%@'",TIMERLISTITEMTABLE, title];
    if ([_dataBase executeUpdate:deleteSql]) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"数据删除失败");
    }
}

//  更新数据
- (void)updateWithTitle:(NSString *)title model:(TimerListItemModel *)model {
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set icon = ?, iconBGColor = ?, title = ?, desc = ? where title = '%@'",TIMERLISTITEMTABLE, title];
    if ([_dataBase executeUpdate:updateSql,model.icon, model.iconBGColor, model.title, model.desc]) {
        NSLog(@"更新数据成功");
    } else {
        NSLog(@"更新数据失败");
    }
}

// 查询所有数据
- (NSArray *)selectAllData {
    NSString *selectSql = [NSString stringWithFormat:@"select * from %@",TIMERLISTITEMTABLE];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    
    NSMutableArray *contentArray = [NSMutableArray array];
    while ([set next]) {
        TimerListItemModel *model = [[TimerListItemModel alloc] init];
        model.title = [set stringForColumn:@"title"];
        model.icon = [set stringForColumn:@"icon"];
        model.iconBGColor = [set stringForColumn:@"iconBGColor"];
        model.desc = [set stringForColumn:@"desc"];
        [contentArray addObject:model];
        
    }
    return contentArray;
}

@end
