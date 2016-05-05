//
//  TwoItemView.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "TwoItemView.h"

@implementation TwoItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
//        CGFloat topMargin = 0;
//        
//        UIView *trainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        trainView.backgroundColor = [UIColor clearColor];
//        [self addSubview:trainView];
//        
//        
//        CGFloat trainBtnWidth = 70;
//        CGFloat trainBtnHeight = trainBtnWidth;
//        UIView *trainBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, trainBtnWidth, trainBtnHeight)];
//        trainBtnView.backgroundColor = [UIColor colorWithRed:0.96 green:0.78 blue:0.00 alpha:1.00];
//        self.trainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.trainBtn.frame = CGRectMake(0, 0, trainBtnWidth, trainBtnHeight);
//        [trainBtnView addSubview:self.trainBtn];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:@"bg"];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.alpha = .5;
        [self addSubview:imageView];
        
        self.trainView = [[[NSBundle mainBundle] loadNibNamed:@"TrainItemView" owner:nil options:nil] lastObject];
        self.trainView.backgroundColor = [UIColor clearColor];
        self.trainView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.5);
        self.trainView.btnBGView.layer.cornerRadius = self.trainView.btnBGView.frame.size.width * 0.5;
        [self addSubview:self.trainView];
        
        
        self.lifeView = [[[NSBundle mainBundle] loadNibNamed:@"LifeItemView" owner:nil options:nil] lastObject];
        self.lifeView.frame = CGRectMake(0, kScreenHeight * 0.5, kScreenWidth, kScreenHeight * 0.5);
        self.lifeView.backgroundColor = [UIColor clearColor];
        self.lifeView.btnBGView.layer.cornerRadius = self.lifeView.btnBGView.frame.size.width * 0.5;
        [self addSubview:self.lifeView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tap];
        
        
    }
    return self;
}

- (void)remove {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
