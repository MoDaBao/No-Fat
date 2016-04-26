//
//  PersonCenterHeaderView.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PersonCenterHeaderView.h"

#define kHeadImageScale (70 / 375.0)// 头像比例

//#define kHeadImageWidth 80// 头像宽度
#define kHeadImageWidth kHeadImageScale * kScreenWidth
#define kHeadImageHeight kHeadImageWidth// 头像高度

//#define kUserViewHeight 230// 用户视图高度
#define kUserViewHeight (250 / 667.0 * 2) * self.frame.size.height
#define UserViewBGColor [UIColor colorWithRed:58 / 255.0 green:60 / 255.0 blue:71 / 255.0 alpha:1.0]// 用户视图背景颜色

#define UserNameWidth kScreenWidth//用户名标签宽度
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
        
        // 滚动延伸背景
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, -kUserViewHeight, kScreenWidth, kUserViewHeight)];
        blackView.backgroundColor = UserViewBGColor;
        [self addSubview:blackView];
        
        // 创建深灰色背景视图
        UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kUserViewHeight)];
        userView.backgroundColor = UserViewBGColor;
        [self addSubview:userView];
        
        // 创建头像视图
//        CGFloat scale = kHeadImageWidth / 375.0;
//        CGFloat headWidth = scale * kScreenWidth;
//        CGFloat headHeight = headWidth;
        CGFloat headX = kScreenWidth * 0.5 - kHeadImageWidth * 0.5;
        CGFloat headY = 40;
//        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, headWidth, headHeight)];
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headX, headY, kHeadImageWidth, kHeadImageHeight)];
        self.headImageView.backgroundColor = [UIColor clearColor];
        self.headImageView.layer.cornerRadius = kHeadImageWidth * 0.5;
        self.headImageView.layer.masksToBounds = YES;// 切割、显示为圆形
        // 截取图片使图片保持原始比例并填充
//        self.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.headImageView.clipsToBounds = YES;
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [userView addSubview:self.headImageView];
        
        // 创建用户名标签
        CGFloat usernameX = kScreenWidth * 0.5 - UserNameWidth * 0.5;
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(usernameX, headY + kHeadImageHeight, UserNameWidth, UserNameHeight)];
//        self.usernameLabel.text = @"游客";
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        [userView addSubview:self.usernameLabel];
        
        // 创建性别视图
        self.genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(usernameX + UserNameWidth, headY + kHeadImageHeight + 10, 17, 17)];
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
//        self.fansCountLabel.text = @"0粉丝";
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
//        self.focusCountLabel.text = @"0关注";
        self.focusCountLabel.textColor = [UIColor whiteColor];
        self.focusCountLabel.font = [UIFont systemFontOfSize:15];
        [userView addSubview:self.focusCountLabel];
        
        UILabel *beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kUserViewHeight, kScreenWidth, frame.size.height - kUserViewHeight)];
        beginLabel.text = @"/    It's a new beginning.    /";
        beginLabel.textAlignment = NSTextAlignmentCenter;
        beginLabel.font = [UIFont boldSystemFontOfSize:22];
//        beginLabel.font = [UIFont fontWithName:@"Arial" size:22];
        [self addSubview:beginLabel];
        
        CGFloat logoutWidth = 40;
        CGFloat logoutHeight = logoutWidth;
        CGFloat logoutX = kScreenWidth - 30 - logoutWidth;
        CGFloat logoutY = userView.frame.size.height - logoutHeight * 0.5;
//        self.logout = [[UIButton alloc] initWithFrame:CGRectMake(logoutX, logoutY, logoutWidth, logoutHeight)];
        self.logout = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.logout setBackgroundImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
        [self.logout setBackgroundColor:[UIColor whiteColor]];
        self.logout.frame = CGRectMake(logoutX, logoutY, logoutWidth, logoutHeight);
//        self.logout.backgroundColor = [UIColor whiteColor];
//        self.logout.image = [UIImage imageNamed:@"logout"];
        self.logout.layer.cornerRadius = logoutWidth * 0.5;
        self.logout.layer.masksToBounds = NO;// 如果设置阴影效果，则必须设置 layer.masksToBounds=NO，不然阴影无效！！
        // 截取图片使图片保持原始比例并填充
        self.logout.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.logout.clipsToBounds = YES;
        self.logout.contentMode = UIViewContentModeScaleAspectFill;
//        self.logout.layer.borderColor = [UIColor blackColor].CGColor;
//        self.logout.layer.borderWidth = 2.0f;
        self.logout.layer.shadowColor = [UIColor blackColor].CGColor;
        self.logout.layer.shadowOffset = CGSizeMake(0, 10);// 阴影偏移量
        self.logout.layer.shadowOpacity = 0.7;// 阴影透明度
        self.logout.layer.shadowRadius = 1.0;// 阴影半径
        self.logout.userInteractionEnabled = YES;
        [self addSubview:self.logout];
        
        
    }
    return self;
}

////  退出登录
//- (void)click {
//    NSLog(@"233333");
//    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确认退出么?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UserInfoManager shareInstance] removeAllUserInfo];// 清除用户的所有信息
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:logoutAction];
//    
//    
//    
//}


@end
