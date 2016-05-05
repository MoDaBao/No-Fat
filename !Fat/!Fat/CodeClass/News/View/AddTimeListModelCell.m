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
    
    NSString *time = [NSString stringWithFormat:@"%@",model.createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.timeLabel.text = confromTimespStr;
    
    self.contentLabel.text = model.content;
    
    
    //拼接图片的网址
    if ([model.image hasPrefix:@"http"]) {
        
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
         }else {
            NSArray *arr = [model.image componentsSeparatedByString:@"/"];
            NSString *imageName = [arr lastObject];
            NSString *image = [NSString stringWithFormat:@"http://ft-video.fit-time.cn/%@@!320", imageName];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
         }
  
    
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
