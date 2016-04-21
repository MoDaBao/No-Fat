//
//  FMDBManager.m
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "FMDBManager.h"

static FMDBManager *dbManager = nil;
@implementation FMDBManager

//  单例方法
+ (FMDBManager *)shareInstanceWithDBName:(NSString *)name {
    @synchronized (self) {
        if (!dbManager) {
            dbManager = [[FMDBManager alloc] initWithDBName:name];
        }
    }
    return dbManager;
}

//  初始化方法
- (instancetype)initWithDBName:(NSString *)name {
    if (self = [super init]) {
        if (!name) {
            NSLog(@"数据库名为空，创建失败");
        } else {
            // 获取沙盒路径
            NSString *documentPatn = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            // 创建数据库路径
            NSString *dbPath = [documentPatn stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
            // isExist = 0 路径不存在  isExists = 1 路径已经存在
            BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
            if (!isExist) {
                NSLog(@"路径不存在，%@",dbPath);
            } else {
                NSLog(@"路径已存在, %@",dbPath);
            }
            
            [self openDataBaseWithDBPath:dbPath];
        }
    }
    return self;
}

//  打开数据库
- (void)openDataBaseWithDBPath:(NSString *)path {
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:path];
    }
    if (![_dataBase open]) {
        NSLog(@"数据库打开失败");
    } else {
        NSLog(@"数据库打开成功");
    }
}

//  关闭数据库
- (void)closeDB {
    [_dataBase close];
    dbManager = nil;
}

- (void)dealloc {
    [self closeDB];
}


@end
