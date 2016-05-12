//
//  AttentionListModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AttentionListModelCell.h"
#import "AttentionListModel.h"

@implementation AttentionListModelCell


- (void)setDataWithModel:(AttentionListModel *)model {
    
    //头像
    NSArray *arr1 = [model.userModel.avatar componentsSeparatedByString:@"/"];
    NSString *imageName1 = [arr1 lastObject];
    
    NSString *image1 = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!640", imageName1];
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:image1]];
    
    //内容图片
    NSArray *arr = [model.image componentsSeparatedByString:@"/"];
    NSString *imageName = [arr lastObject];
    
    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    self.userName.text = model.userModel.username;
    
    
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
    

    self.contrentLabel.text = model.content;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
    self.textHeight = model.textHeight;
//    NSLog(@"%f", model.textHeight);
    
    
}


- (CGFloat)cellHeight
{
    
//    NSLog(@"%f, %f",CGRectGetMinY(self.contentImageView.frame), CGRectGetMaxY(self.contrentLabel.frame));
//    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
//    CGFloat textH = [self.contrentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    //计算
    return CGRectGetMinY(self.contrentLabel.frame) + self.textHeight + 20 +( CGRectGetMaxY(self.commentCountLabel.frame) - CGRectGetMinY(self.contentImageView.frame) + 20);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
