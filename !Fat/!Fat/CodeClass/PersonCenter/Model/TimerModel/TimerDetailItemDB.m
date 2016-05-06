//
//  TimerDetailItemDB.m
//  Timer
//
//  Created by 莫大宝 on 16/5/1.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerDetailItemDB.h"
#import "TimerDetailItemModel.h"
#import "TimerListItemDB.h"

@implementation TimerDetailItemDB

- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [FMDBManager shareInstanceWithDBName:DATABASENAME].dataBase;
    }
    return self;
}

//  创建表
- (void)createTable {
    NSString *selectSql = [NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",TIMERDETAILITEMTABLE];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已存在");
    } else {
        // 创建表
        NSString *createSql = [NSString stringWithFormat:@"create table %@(title text primary key, titlecolor text, titleicon, countdown int, loopcount int, step text)",TIMERDETAILITEMTABLE];
        if ([_dataBase executeUpdate:createSql]) {
            NSLog(@"数据表创建成功");
        } else {
            NSLog(@"数据表创建失败");
        }
    }
}
//  插入数据
- (void)insertTimerDetailItemModel:(TimerDetailItemModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(title, titlecolor, titleicon, countdown, loopcount, step) values(?, ?, ?, ?, ?, ?)",TIMERDETAILITEMTABLE];
    if ([_dataBase executeUpdate:insertSql,model.title, model.titlecolor, model.titleicon, model.countdown, model.loopcount, model.step]) {
        NSLog(@"数据插入成功");
        TimerListItemModel *listItem = [[TimerListItemModel alloc] init];
        listItem.title = model.title;
        listItem.icon = model.titleicon;
        listItem.iconBGColor = model.titlecolor;
        NSArray *array = [model.step componentsSeparatedByString:@"/"];
        listItem.desc = [NSString stringWithFormat:@"%d秒倒计时，%ld个步骤，%d个循环",[model.countdown intValue], array.count, [model.loopcount intValue]];
        TimerListItemDB *listItemDB = [[TimerListItemDB alloc] init];
        [listItemDB insertTimerListItemModel:listItem];
    } else {
        NSLog(@"数据插入失败");
    }
}
//  删除数据
- (void)deleteWithTitle:(NSString *)title {
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where title = '%@'",TIMERDETAILITEMTABLE, title];
    if ([_dataBase executeUpdate:deleteSql]) {
        NSLog(@"删除成功");
        
    } else {
        NSLog(@"删除失败");
    }
}
//  更新数据
- (void)updateWithTitle:(NSString *)title model:(TimerDetailItemModel *)model {
    NSString *updateSql = [NSString stringWithFormat:@"update %@ set title = ?, titlecolor = ?, titleicon = ?, countdown = ?, loopcount = ?, step = ? where title = '%@'",TIMERDETAILITEMTABLE, title];
    if ([_dataBase executeUpdate:updateSql,model.title, model.titlecolor, model.titleicon, model.countdown, model.loopcount, model.step]) {
        NSLog(@"更新数据成功");
        TimerListItemModel *listItem = [[TimerListItemModel alloc] init];
        listItem.title = model.title;
        listItem.icon = model.titleicon;
        listItem.iconBGColor = model.titlecolor;
        NSArray *array = [model.step componentsSeparatedByString:@"/"];
        listItem.desc = [NSString stringWithFormat:@"%d秒倒计时，%ld个步骤，%d个循环",[model.countdown intValue], array.count, [model.loopcount intValue]];
        TimerListItemDB *listItemDB = [[TimerListItemDB alloc] init];
        [listItemDB updateWithTitle:title model:listItem];
    } else {
        NSLog(@"更新数据失败");
    }
}
//  查找指定数据
- (TimerDetailItemModel *)selectDataWithTitle:(NSString *)tilte {
    NSString *selectSql = [NSString stringWithFormat:@"select * from %@ where title = '%@'",TIMERDETAILITEMTABLE, tilte];
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    NSMutableArray *mArr = [NSMutableArray array];
//    while ([set next]) {
    [set next];
    TimerDetailItemModel *model = [[TimerDetailItemModel alloc] init];
    model.title = [set stringForColumn:@"title"];
    model.titlecolor = [set stringForColumn:@"titlecolor"];
    model.titleicon = [set stringForColumn:@"titleicon"];
//    int countdown = [set intForColumn:@"countdown"];
    model.countdown = [NSNumber numberWithInt:[set intForColumn:@"countdown"]];
    model.loopcount = [NSNumber numberWithInt:[set intForColumn:@"loopcount"]];
    model.step = [set stringForColumn:@"step"];
    [mArr addObject:model];
//    }
    return model;
}

@end
