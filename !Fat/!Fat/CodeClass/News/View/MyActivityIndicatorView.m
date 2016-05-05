//
//  MyActivityIndicatorView.m
//  EaseLoading
//
//  Created by hu胡洁佩 on 16/5/4.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "MyActivityIndicatorView.h"


@implementation MyActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 菊花背景的大小
        self.frame = CGRectMake(ScreenWidth/2-50, ScreenHeight/2-150, 100, 100);
        // 菊花的背景色
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        // 菊花的颜色和格式（白色、白色大、灰色）
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        // 在菊花下面添加文字
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 40)];
        label.text = @"loading...";
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [self addSubview:label];
    }
    return  self;
}
@end
