//
//  TimerDetailItemModel.h
//  Timer
//
//  Created by 莫大宝 on 16/4/18.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface TimerDetailItemModel : BaseModel

@property (nonatomic, copy) NSString *title;// 计时器标题
@property (nonatomic, copy) NSString *titlecolor;// 图标颜色
@property (nonatomic, copy) NSString *titleicon;// 图标
@property (nonatomic, strong) NSNumber *countdown;// 倒计时
@property (nonatomic, strong) NSNumber *loopcount;// 循环次数
@property (nonatomic, copy) NSString *step;// 步骤

@end
