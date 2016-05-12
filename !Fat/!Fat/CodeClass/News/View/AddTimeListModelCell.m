//
//  AddTimeListModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddTimeListModelCell.h"
#import "AddTimeListModel.h"

@implementation AddTimeListModelCell

- (void)setDataWithModel:(AddTimeListModel *)model {
    
//    self.nameLabel.text = @"宋仲基";
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@"back"]];
    
    
    self.contentLabel.text = model.content;
    
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
    
    
    [self.trainingText setTitle:[NSString stringWithFormat:@"%@ . %@", model.trainingType, model.trainingVolume] forState:UIControlStateNormal];
    
    //拼接图片的网址
//    if ([model.image hasPrefix:@"http"]) {
//        
//        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
//         }else {
            NSArray *arr = [model.image componentsSeparatedByString:@"/"];
            NSString *imageName = [arr lastObject];
            NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@", imageName];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
//         }
  
    
    self.pariseCountLabrl.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
   
    //在model上计算的label的高度赋给声明的属性
    self.textHeight = model.textHeight;
    
    
}
- (CGFloat)cellHeight
{
    //计算 整个cell的高度
    return CGRectGetMinY(self.contentLabel.frame) + self.textHeight + 20 +( CGRectGetMaxY(self.commentCountLabel.frame) - CGRectGetMinY(self.contentImageView.frame) + 20);
    
}
//点击button的方法
- (IBAction)gunazhuBttton:(id)sender {
    
    
    
    
}

@end
