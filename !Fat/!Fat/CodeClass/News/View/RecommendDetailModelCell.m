//
//  RecommendDetailModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendDetailModelCell.h"
#import "RecommendDetailModel.h"
#import "UserMessageViewController.h"

@implementation RecommendDetailModelCell
- (void)awakeFromNib{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    NSLog(@"11111");
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:tap];
    
}

- (void)tap:(UIGestureRecognizer *)tap {

  
    if (self.tapBlock) {
        self.tapBlock();
    }
   
    NSLog(@"ssssssss");
}

- (void)setDataWithModel:(RecommendDetailModel *)model {
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
//    self.userNameLabel.text = @"仲基";
    self.contentLabel.text = model.comment;
    
    
    //转换时间
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
    
    
    
    
    if (model.praiseCount > 0) {
         self.praiseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    }else {
        self.praiseCountLabel.hidden = YES;
    }
    
     self.textHeight = model.textHeight;
   
   
}



- (CGFloat)cellHeight
{
    //计算
    return CGRectGetMinY(self.contentLabel.frame) + self.textHeight + 20;
    
}

- (IBAction)dianzanBT:(id)sender {
}

@end
