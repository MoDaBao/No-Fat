//
//  AlterTitleViewController.h
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
#import "TimerDetailItemModel.h"

typedef void(^PassValue)(NSString *);
@interface AlterTitleViewController : BaseViewController

@property (nonatomic, strong) TimerDetailItemModel *detailItemModel;

@property (nonatomic, copy) PassValue passValue;
@end
