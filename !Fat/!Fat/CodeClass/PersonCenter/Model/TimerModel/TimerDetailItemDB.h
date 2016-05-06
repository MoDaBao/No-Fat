//
//  TimerDetailItemDB.h
//  Timer
//
//  Created by 莫大宝 on 16/5/1.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerDetailItemModel.h"

@interface TimerDetailItemDB : NSObject

@property (nonatomic, strong) FMDatabase *dataBase;

//  创建表
- (void)createTable;
//  插入数据
- (void)insertTimerDetailItemModel:(TimerDetailItemModel *)model;
//  删除数据
- (void)deleteWithTitle:(NSString *)title;
//  更新数据
- (void)updateWithTitle:(NSString *)title model:(TimerDetailItemModel *)model;
//  查找指定数据
- (TimerDetailItemModel *)selectDataWithTitle:(NSString *)tilte;

@end
