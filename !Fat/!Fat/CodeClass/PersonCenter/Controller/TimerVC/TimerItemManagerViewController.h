//
//  TimerItemManagerViewController.h
//  Timer
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
#import "TimerDetailItemDB.h"
#import "TimerListItemModel.h"

@interface TimerItemManagerViewController : BaseViewController

@property (nonatomic, assign) NSInteger isNew;// 判断是否为最新
//@property (nonatomic, strong) TimerListItemModel *timerDetailItemModel;
@property (nonatomic, strong) TimerDetailItemModel *selectModel;// 数据库中某一项
@property (nonatomic, copy) NSString *headTitle;

@end
