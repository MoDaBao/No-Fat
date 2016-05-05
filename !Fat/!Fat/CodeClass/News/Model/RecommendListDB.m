//
//  RecommendListDB.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RecommendListDB.h"

@implementation RecommendListDB


- (instancetype)init {
    if (self = [super init]) {
        _dataBase = [FMDBManager shareInstanceWithDBName:DATABASENAME].dataBase;
    }
    return  self;
}

//创建表
- (void)createDataTable {
    //查询数据中的元素个数
    FMResultSet *set = [_dataBase executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type = 'table' and name = '%@'",RECOMMENDLISTTABLE]];
    [set next];
    NSInteger count = [set intForColumnIndex:0];
    if (count) {
        NSLog(@"数据表已经存在");
    }else {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (ID TEXT, userID TEXT, content TEXT, contentCount TEXT, praiseCount TEXT)", RECOMMENDLISTTABLE];
        BOOL res = [_dataBase executeUpdate:sql];
        if (!res) {
            NSLog(@"数据表创建失败");
        }else {
            NSLog(@"数据表创建成功");
        }
    }
    
    
}

//添加一条数据
- (void)addDetailModel:(RecommendListModel *)listModel {
    // 创建插入数据
    NSMutableString *string = [NSMutableString stringWithFormat:@"INSERT INTO %@ (ID,userID,content,contentCount,contentCount) values (?,?,?,?,?)", RECOMMENDLISTTABLE];
    NSMutableArray *array  = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![[UserInfoManager shareInstance].getUserID isEqualToString:@" "]) {
        [array addObject:[UserInfoManager shareInstance].getUserID];
    }
    if (listModel.ID) {
        NSString *ID = listModel.ID.stringValue;
        [array addObject:ID];
    }
    if (listModel.content) {
        [array addObject:listModel.content];
    }
    if (listModel.commentCount) {
        [array addObject:listModel.commentCount];
    }
    if (listModel.praiseCount) {
        [array addObject:listModel.praiseCount];
    }
    NSLog(@"string%@", string);
    NSLog(@"收藏了一条数据");
    
    [_dataBase executeUpdate:string withArgumentsInArray:array];
    
}

//删除一条数据
- (void)deleteDetailWithContent:(NSString *)content {
    NSString *string = [NSString stringWithFormat:@"delete from %@  where content is '%@'", RECOMMENDLISTTABLE, content];
    NSLog(@"删除成功");
    [_dataBase executeUpdate:string];
}

//查找所有数据
- (NSArray *)selectDetailModelWithUserID:(NSString *)userID {
    
    NSString *string = [NSString stringWithFormat:@"select * from %@ where userID = %@", RECOMMENDLISTTABLE, userID];
    
    FMResultSet *set = [self.dataBase executeQuery:string];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[set columnCount]];
    while ([set next]) {
        RecommendListModel *model = [[RecommendListModel alloc] init];
        
        model.userId = (NSNumber *)[set stringForColumn:@"userID"];
        model.ID = (NSNumber *)[set stringForColumn:@"ID"];
        model.content = [set stringForColumn:@"content"];
        model.commentCount = (NSNumber *)[set stringForColumn:@"commentCount"];
        model.praiseCount = (NSNumber *)[set stringForColumn:@"praiseCount"];
       
        [array addObject:model];
    }
    [set close];
    return array;
    
}
@end
