//
//  AddTimeNoImageModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/21.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddTimeNoImageModelCell.h"
#import "AddTimeListModel.h"

@implementation AddTimeNoImageModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setDataWithModel:(AddTimeListModel *)model {
    
//    self.nameLabel.text = @"宋仲基";
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@"back"]];
//
    NSNumber *createTime = model.createTime;
    NSDate *date = [NSDate date];
    NSInteger time = [date timeIntervalSince1970];
    NSInteger space = time - createTime.integerValue / 1000;
    NSInteger spacetime = space / (60 * 60);
    if (spacetime < 24 & spacetime > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",spacetime];
    } else if (spacetime < 1) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",space / 60];
    } else {
        //        double time = [[dic.allValues firstObject] doubleValue] / 1000;
        //        CGFloat year = time /
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime.integerValue / 1000];
        //将一个日期对象转化为字符串对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置日期与字符串互转的格式
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //将日期转化为字符串
        NSString *dateStr = [formatter stringFromDate:date];
        self.timeLabel.text = dateStr;
    }
    
    
    self.contentLabel.text = model.content;
    self.pariseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
    
   [self.trainingTextBT setTitle:[NSString stringWithFormat:@"%@ . %@", model.trainingType, model.trainingVolume] forState:UIControlStateNormal];
    self.textHeight = model.textHeight;
    
}

//点击关注按钮的方法
- (IBAction)guanzhuBT:(id)sender {
}
- (CGFloat)cellHeight
{
    //计算
    return CGRectGetMinY(self.contentLabel.frame) + self.textHeight + 20 +( CGRectGetMaxY(self.commentCountLabel.frame) - CGRectGetMinY(self.button.frame) + 20);
    
}

@end
