//
//  UserNameAndGenderView.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//
//  暂时没用到的类

#import "UserNameAndGenderView.h"

@implementation UserNameAndGenderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建用户名标签
//        CGFloat usernameX = kScreenWidth * 0.5 - UserNameWidth * 0.5;
//        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(usernameX, headY + kHeadImageHeight, UserNameWidth, UserNameHeight)];
        //        self.usernameLabel.text = @"游客";
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 12, frame.size.height)];
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.usernameLabel];
        
        // 创建性别视图
//        self.genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(usernameX + UserNameWidth, headY + kHeadImageHeight + 10, 12, 12)];
        self.genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.usernameLabel.frame.size.width, 0, 12, 12)];
        self.genderImageView.image = [UIImage imageNamed:@"female"];
        [self addSubview:self.genderImageView];
    }
    return self;
}

@end
