//
//  UserTrainDB.m
//  !Fat
//
//  Created by lanou on 16/4/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserTrainDB.h"

@implementation UserTrainDB

//重写初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataBase = [FMDBManager shareInstanceWithDBName:DATABASENAME].dataBase;
    }
    return self;
}

//创建表
- (void)createDataTable {
    
    //查询数据表中的元素个数
    FMResultSet *set = [self.dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@' ",PROGRAMLISTTABLE]];
    [set next];//结果集中就一条记录 且一个字段 无列名
    NSInteger count = [set intForColumnIndex:0];//获取整形字段的信息
    if (count) {
        
        //不为0 表已经存在
        NSLog(@"数据表已经存在");
    } else {
        //表不存在 创建新的表
        NSString *createSql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, userID TEXT, programID TEXT)",PROGRAMLISTTABLE];
        
        BOOL result = [self.dataBase executeUpdate:createSql];
        if (!result) {
            NSLog(@"数据表创建失败");
        } else {
            NSLog(@"数据表创建成功");
        }
    }
}

//插入
- (void)insertDataWithModel:(ProgramModel *)model {
    //创建sql语句
    NSMutableString *insertSql = [NSMutableString stringWithFormat:@"insert into %@(userID, programID) values(?, ?)",PROGRAMLISTTABLE];
    //创建插入内容
    NSMutableArray *arguments = [NSMutableArray array];
    
    NSString *userID = [[UserInfoManager shareInstance] getUserID];
    if (![userID isEqualToString:@" "]) {
        [arguments addObject:userID];
    }
    if (model.programID) {
        [arguments addObject:model.programID];
    }
    //执行
    [self.dataBase executeUpdate:insertSql withArgumentsInArray:arguments];
}

//删除
- (void)deleteDataWithProgramID:(NSString *)programID {
    NSString *delSql = [NSString stringWithFormat:@"delete from %@ where programID = '%@'",PROGRAMLISTTABLE, programID];
    [self.dataBase executeUpdate:delSql];
}

//查询
- (NSArray *)selectDataWithUserID:(NSString *)userID {
    NSString *selectSql = [NSString stringWithFormat:@"select * from %@ where userID = '%@'",PROGRAMLISTTABLE, userID];
    FMResultSet *set = [self.dataBase executeQuery:selectSql];
    
    NSMutableArray *listArray = [NSMutableArray array];
    
    while ([set next]) {
        ProgramModel *programModel = [[ProgramModel alloc] init];
        programModel.programID = [set stringForColumn:@"programID"];
        [listArray addObject:programModel];
    }
    
    [set close];
    
    return listArray;
}


@end
