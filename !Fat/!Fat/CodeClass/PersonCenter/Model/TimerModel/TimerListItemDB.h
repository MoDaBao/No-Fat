//
//  TimerListItemDB.h
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerListItemModel.h"

@interface TimerListItemDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

//  创建表
- (void)createTable;

//  插入数据
- (void)insertTimerListItemModel:(TimerListItemModel *)model;

//  删除数据
- (void)deleteWithTitle:(NSString *)title;

//  更新数据
- (void)updateWithTitle:(NSString *)title model:(TimerListItemModel *)model;

// 查询所有数据
- (NSArray *)selectAllData;

@end
