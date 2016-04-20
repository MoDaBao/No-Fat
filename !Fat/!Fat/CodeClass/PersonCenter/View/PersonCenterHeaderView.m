//
//  PersonCenterHeaderView.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PersonCenterHeaderView.h"

#define kHeadImageWidth 90// 头像宽度
#define kHeadImageHeight 90// 头像高度

#define kUserViewHeight 230// 用户视图高度
#define UserViewBGColor [UIColor colorWithRed:58 / 255.0 green:60 / 255.0 blue:71 / 255.0 alpha:1.0]// 用户视图背景颜色

#define UserNameWidth 60//用户名标签宽度
#define UserNameHeight 40//用户名标签宽度

@implementation PersonCenterHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        // 创建深灰色背景视图
        UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kUserViewHeight)];
        userView.backgroundColor = UserViewBGColor;
        [self addSubview:userView];
        
        // 创建头像视图
        CGFloat headX = kScreenWidth * 0.5 - kHeadImageWidth * 0.5;
        CGFloat headY = 40;
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, kHeadImageWidth, kHeadImageHeight)];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.layer.cornerRadius = kHeadImageWidth * 0.5;
        [userView addSubview:self.headImageView];
        
        // 创建用户名标签
        CGFloat usernameX = kScreenWidth * 0.5 - UserNameWidth * 0.5;
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(usernameX, headY + kHeadImageHeight, UserNameWidth, UserNameHeight)];
        self.usernameLabel.text = @"莫大宝";
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        [userView addSubview:self.usernameLabel];
        
        // 创建性别视图
        self.genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(usernameX + UserNameWidth, headY + kHeadImageHeight + 10, 12, 12)];
        self.genderImageView.image = [UIImage imageNamed:@"female"];
        [userView addSubview:self.genderImageView];
        
        // 创建分割线标签
        CGFloat labelWidth = 20;
        CGFloat labelHeight = 20;
        CGFloat labelX = kScreenWidth * 0.5 - labelWidth * 0.5;
        CGFloat labelY = headY + kHeadImageHeight + UserNameHeight;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.text = @"|";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [userView addSubview:label];
        
        // 创建粉丝标签
        CGFloat fansWidth = 50;
        CGFloat fansHeight = labelHeight;
        CGFloat fansX = labelX - fansWidth;
        CGFloat fansY = labelY;
        self.fansCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(fansX, fansY, fansWidth, fansHeight)];
        self.fansCountLabel.text = @"1粉丝";
        self.fansCountLabel.textColor = [UIColor whiteColor];
        self.fansCountLabel.textAlignment = NSTextAlignmentRight;
        self.fansCountLabel.font = [UIFont systemFontOfSize:15];
        [userView addSubview:self.fansCountLabel];
        
        // 创建关注标签
        CGFloat focusWith = fansWidth;
        CGFloat focusHeight = fansHeight;
        CGFloat focusX = labelX + labelWidth;
        CGFloat focusY = labelY;
        self.focusCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(focusX, focusY, focusWith, focusHeight)];
        self.focusCountLabel.textAlignment = NSTextAlignmentLeft;
        self.focusCountLabel.text = @"3关注";
        self.focusCountLabel.textColor = [UIColor whiteColor];
        self.focusCountLabel.font = [UIFont systemFontOfSize:15];
        [userView addSubview:self.focusCountLabel];
        
        
    }
    return self;
}


@end
