//
//  AddNewsView.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddNewsView.h"
#import "TwoItemView.h"

@implementation AddNewsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.78 blue:0.00 alpha:1.00];
        self.alpha = .8;
        CGFloat btnWidht = self.frame.size.width * 0.5;
        CGFloat btnHeight = self.frame.size.height * 0.5;
        CGFloat btnX = btnWidht - btnWidht * 0.5;
        CGFloat btnY = btnHeight - btnHeight * 0.5;
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.frame = CGRectMake(btnX, btnY, btnWidht, btnHeight);
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        self.layer.cornerRadius = self.frame.size.height * 0.5;
    
        [self addSubview:self.addBtn];
    }
    return self;
}

//- (void)add {
//    NSLog(@"2333");
//    
////    [UIView animateWithDuration:.2 animations:^{
//////        self.backgroundColor = [UIColor colorWithRed:0.55 green:0.48 blue:0.12 alpha:1.00];
////    } completion:^(BOOL finished) {
////        
////    }];
//    
//    TwoItemView *twoView = [[TwoItemView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    
//    
//}


@end
