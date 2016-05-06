//
//  TimerDetailItemStepCell.h
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
typedef void(^ClickBlock)();
@interface TimerDetailItemStepCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *stepName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *alterBtn;
@property (nonatomic, copy) ClickBlock click;

@end
