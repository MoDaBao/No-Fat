//
//  UserTrainDB.h
//  !Fat
//
//  Created by lanou on 16/4/24.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgramModel.h"

@interface UserTrainDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

//创建表
- (void)createDataTable;
//插入
- (void)insertDataWithModel:(ProgramModel *)model;
//删除
- (void)deleteDataWithProgramID:(NSString *)programID;
//查询
- (NSArray *)selectDataWithUserID:(NSString *)userID;

@end
