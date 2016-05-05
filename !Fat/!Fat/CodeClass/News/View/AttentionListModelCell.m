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
    
    
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.createTime];
//    NSString *time = [NSString stringWithFormat:@"%@",model.createTime];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
//    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];             
//
//    NSDate *date = [formatter dateFromString:time]
    
    self.timeLabel.text = [self timeFormatted:(int)model.createTime];

    self.contrentLabel.text = model.content;
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
    self.textHeight = model.textHeight;
//    NSLog(@"%f", model.textHeight);
    
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int totalSeconds1 = totalSeconds / 1000;
    int seconds = totalSeconds1 % 60;
    int minutes = (totalSeconds1 / 60) % 60;
    int hours = totalSeconds1 / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
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
