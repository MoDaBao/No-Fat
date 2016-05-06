//
//  TimerDetailItemStepCell.m
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerDetailItemStepCell.h"
#import "TimerDetailItemModel.h"

@implementation TimerDetailItemStepCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)alter:(id)sender {
    self.click();
    NSLog(@"点击了按钮");
}

//- (void)setDataWithModel:(TimerDetailItemModel *)model {
//    
//}

@end
