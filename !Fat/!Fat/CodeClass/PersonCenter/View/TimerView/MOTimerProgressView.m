//
//  MOProgressView.m
//  test
//
//  Created by 莫大宝 on 16/5/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MOTimerProgressView.h"
#import "UIView+ChangeFrame.h"
#define kMargin 8

@interface  MOTimerProgressView ()

@property (nonatomic, assign) CGFloat originx;
@property (nonatomic, assign) CGFloat originy;
@property (nonatomic, assign) CGFloat nowx;
@property (nonatomic, strong) UIColor *color;


@end

@implementation MOTimerProgressView

- (instancetype)initWithFrame:(CGRect)frame loopTime:(NSTimeInterval)loopTimer bgColor:(UIColor *)bgColor {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = bgColor;
        self.originx = self.width - kMargin;
        self.originy = self.centerY;
        self.nowx = self.originx;
        self.color = bgColor;
        CGFloat width = self.width - kMargin * 2;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:loopTimer * 1.0 / width target:self selector:@selector(time) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:@"123"];
    }
    return self;
}


- (void)time {
    NSLog(@"232333");
    //    CGContextRef ctf = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(ctf, kMargin);
    //    CGContextSetLineCap(ctf, kCGLineCapRound);
    //    CGContextMoveToPoint(ctf, self.originx, self.originy);
    //    CGContextAddLineToPoint(ctf, self.originx--, self.originy);
    //    [self.color set];
    //    CGContextStrokePath(ctf);
    
    if (self.nowx == kMargin - 1) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self setNeedsDisplay];
    }
    
    
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    
    CGFloat margin = kMargin;
    
    // 获取图形上下文
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    // 设置线宽
    CGContextSetLineWidth(ctf, margin);
    // 设置头尾部样式
    //    CGContextSetLineCap(ctf, kCGLineCapRound);
    // 画线
    CGContextMoveToPoint(ctf, margin, self.centerY);
    CGContextAddLineToPoint(ctf, self.width - margin, self.centerY);
    // 设置颜色
    [[UIColor blackColor] set];
    
    // 绘制图形
    CGContextStrokePath(ctf);
    
    //CGFloat radius 半径
    //CGFloat startAngle 开始角度
    //CGFloat endAngle 结束角度
    //int clockwise 圆弧伸展方向  顺时针还是逆时针 0顺时针  1逆时针
    CGContextSetLineWidth(ctf, 1);
    CGContextAddArc(ctf, margin, self.centerY, margin, M_PI_2, M_PI + M_PI_2, 0);
    CGContextStrokePath(ctf);// 左边圆弧
    
    CGContextMoveToPoint(ctf, margin, self.centerY - margin);
    CGContextAddLineToPoint(ctf, self.width - margin, self.centerY - margin);
    CGContextStrokePath(ctf);// 上方直线
    
    CGContextAddArc(ctf, self.width - margin, self.centerY, margin, M_PI_2, M_PI + M_PI_2, 1);
    CGContextStrokePath(ctf);// 右边圆弧
    
    CGContextMoveToPoint(ctf, margin, self.centerY + margin);
    CGContextAddLineToPoint(ctf, self.width - margin, self.centerY + margin);
    CGContextStrokePath(ctf);// 下方直线
    
    
    CGContextSetLineWidth(ctf, kMargin);
    CGContextMoveToPoint(ctf, self.originx, self.originy);
    CGContextAddLineToPoint(ctf, self.nowx--, self.originy);
    // 测试
//    [[UIColor redColor] set];
    [self.color set];
    CGContextStrokePath(ctf);
    
    
    
//    //测试
//    CGContextRef ctf = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctf, 5);
//    [[UIColor blackColor] set];
//    CGContextMoveToPoint(ctf, 100, 100);
//    CGContextAddLineToPoint(ctf, 100, 200);
//    CGContextStrokePath(ctf);
    
    
}


@end
