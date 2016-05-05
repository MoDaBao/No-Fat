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
//    NSString *str = [NSString stringWithFormat:@"%@", model.createTime / 1000];
    NSString *time = [NSString stringWithFormat:@"%@",model.createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    self.timeLabel.text = confromTimespStr;
    
    self.contentLabel.text = model.content;
    self.pariseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
    
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
