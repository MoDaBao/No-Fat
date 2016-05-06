//
//  TimerDetailItemOtherCell.m
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerDetailItemOtherCell.h"


@implementation TimerDetailItemOtherCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(TimerDetailItemModel *)model indexPath:(NSIndexPath *)indexPath {
//    [self assignmentWithImageView:self.icon color:model.titlecolor];
//    self.title.text = model.title;
//    self.icon.image = [UIImage imageNamed:model.titleicon];
    if (indexPath.row == 0) {
        [self assignmentWithImageView:self.icon color:model.titlecolor];
        self.title.text = [NSString stringWithFormat:@"标题:%@",model.title];
        self.icon.image = [UIImage imageNamed:model.titleicon];
    } else if (indexPath.row == 1) {
        self.icon.image = [UIImage imageNamed:@"hourpointer"];
        self.title.text = [NSString stringWithFormat:@"%d秒倒计时",[model.countdown intValue]];
    } else {
        self.icon.image = [UIImage imageNamed:@"loop"];
        self.title.text = [NSString stringWithFormat:@"%d轮",[model.loopcount intValue]];
    }
    
    self.icon.layer.cornerRadius = 10;
}


// 给颜色赋值
- (void)assignmentWithImageView:(UIImageView *)imageView color:(NSString *)color {
    if ([color isEqualToString:@"kPink"]) {
        imageView.backgroundColor = kPink;
    } else if ([color isEqualToString:@"kGray"]) {
        imageView.backgroundColor = kGray;
    } else if ([color isEqualToString:@"kGreen"]) {
        imageView.backgroundColor = kGreen;
    } else if ([color isEqualToString:@"kBlue"]) {
        imageView.backgroundColor = kBlue;
    }
    
}
@end
