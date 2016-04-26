//
//  MyNewsCell.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MyNewsCell.h"


@implementation MyNewsCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat margin = 10;
        CGFloat headWidth = 40;
        CGFloat headHeight = headWidth;
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, headWidth, headHeight)];
        self.headImageView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.0];
        self.headImageView.layer.cornerRadius = headWidth * 0.5;
        self.headImageView.layer.masksToBounds = YES;// 切割、显示为圆形
        // 截取图片使图片保持原始比例并填充
//        self.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;// 这个并不需要
        self.headImageView.clipsToBounds = YES;
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headImageView];
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headWidth + margin * 2, margin, 100, 22)];
        self.usernameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.usernameLabel];
        
        CGFloat timeHeight = 12;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height, 100, timeHeight)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLabel];
        
        CGFloat contentMargin = 20;
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.timeLabel.frame.origin.y + margin + self.timeLabel.frame.size.height, kScreenWidth - self.usernameLabel.frame.origin.x - contentMargin, 20)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.contentLabel];
        
        CGFloat imageMargin = self.usernameLabel.frame.origin.x;
        CGFloat imageWidth = kScreenWidth - imageMargin * 2;
        self.newsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.origin.x, self.contentLabel.frame.origin.y + margin + self.contentLabel.frame.size.height, imageWidth, imageWidth)];
        [self.contentView addSubview:self.newsImageView];
        
    }
    return self;
}

- (void)setDataWithModel:(MyNewsModel *)model {
    // 加载头像
    NSArray *array = [[[UserInfoManager shareInstance] gettUserAvatar] componentsSeparatedByString:@"/"];
    if (![array[0] isEqualToString:@" "]) {// 如果有头像则加载
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640", array[0], array[1]]]];
    } else {
        self.headImageView.image = [UIImage imageNamed:@"head"];
    }
//    self.headImageView.frame = CGRectMake(10, 10, 30, 30);
    
    // 加载用户名
    if ([[[UserInfoManager shareInstance] getUserName] isEqualToString:@"游客"] && ![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        //        self.headerView.usernameLabel.text = @"请添加用户名";
        self.usernameLabel.text = [NSString stringWithFormat:@"!Fat_%@",[[UserInfoManager shareInstance] getUserID]];
    } else {
        self.usernameLabel.text = [[UserInfoManager shareInstance] getUserName];
    }
    
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
    CGFloat contentHeight = [UILabel getHeightByWidth:self.contentLabel.frame.size.width title:model.content font:self.contentLabel.font];
    CGFloat orginHeight = self.contentLabel.frame.size.height;
    CGRect newFrame = self.contentLabel.frame;
    newFrame.size.height = contentHeight;
    self.contentLabel.frame = newFrame;
    
    if (model.image) {
        self.newsImageView.hidden = NO;
        CGRect newImageFrame = self.newsImageView.frame;
        newImageFrame.origin.y += self.contentLabel.frame.size.height - orginHeight;
        NSArray *array = [model.image componentsSeparatedByString:@"/"];
        [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.fit-time.cn/%@", array[0], array[1]]]];
        self.newsImageView.frame = newImageFrame;
    }
    else {
        self.newsImageView.hidden = YES;
    }

}


//+ (CGFloat)cellHeightForCell:(MyNewsModel *)model {
//    if (model.image) {
//        
//    }
//}



@end
