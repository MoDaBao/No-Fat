//
//  RecommendListDB.h
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBManager.h"
#import "RecommendListModel.h"

@interface RecommendListDB : NSObject



@property (nonatomic, strong) FMDatabase *dataBase;

//创建表
- (void)createDataTable;

//添加一条数据
- (void)addDetailModel:(RecommendListModel *)listModel;

//删除一条数据
- (void)deleteDetailWithContent:(NSString *)content;

//查找所有数据
- (NSArray *)selectDetailModelWithUserID:(NSString *)userID;

@end
