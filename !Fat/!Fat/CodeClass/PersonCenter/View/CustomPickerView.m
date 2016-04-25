//
//  CustomPickerView.m
//  test
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "CustomPickerView.h"
#import "UILabel+LabelHeightAndWidth.h"
//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation CustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//  自定义初始化方法
+ (CustomPickerView *)cretaCustomPickerViewWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSMutableArray *)dataArray {
    CustomPickerView *custom = [[CustomPickerView alloc] initWithFrame:frame dataArray:dataArray];
    custom.titleLabel.text = title;
    CGFloat width = [UILabel getWidthWithTitle:title font:custom.titleLabel.font];
    custom.titleLabel.frame = CGRectMake(kScreenWidth * 0.5 - width * 0.5, 0, width, 30);
    return custom;
}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray {
    if (self = [super initWithFrame:frame]) {
        
        self.dataArray = [NSMutableArray array];
        for (NSString *item in dataArray) {
            [self.dataArray addObject:item];
        }
        
        CGFloat pickerHeight = kScreenHeight / 3.0;// pickView高度
        CGFloat btnWidth = 50;// 按钮宽度
        CGFloat btnHeight = 30;// 按钮高度
        CGFloat contentHeight = btnHeight + pickerHeight;// 内容视图高度
        
        // 遮罩层
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [backgroundView setTag:6666];
        backgroundView.backgroundColor = [UIColor lightGrayColor];
        backgroundView.alpha = 0.0;
        [self addSubview:backgroundView];
        // 给遮罩层添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [backgroundView addGestureRecognizer:tap];
        
        // 内容视图
//        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - contentHeight, kScreenWidth, contentHeight)];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, contentHeight)];
        [contentView setTag:2333];
        [self addSubview:contentView];
        
        
        // 标题&按钮视图
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, btnHeight)];
        titleView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:titleView];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.cancelBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:self.cancelBtn];
        
        self.confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmBtn.frame = CGRectMake(kScreenWidth - btnWidth, 0, btnWidth, btnHeight);
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:self.confirmBtn];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [titleView addSubview:self.titleLabel];
        
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, contentHeight - pickerHeight, kScreenWidth, pickerHeight)];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:self.pickerView];
        
        
        CGRect newFrame = contentView.frame;
        newFrame.origin.y = newFrame.origin.y - contentHeight;
        [UIView animateWithDuration:.4 animations:^{
            backgroundView.alpha = 0.2;
            contentView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    return self;
    
}

//  确定按钮方法
- (void)confirm {
    if (self.choseItemString) {
        self.click(self.choseItemString);
    } else {
        self.click(self.dataArray[0]);
    }
    [self hide];
    
}

//  遮罩层手势方法和按钮方法
- (void)hide {
    UIView *view = [self viewWithTag:6666];
    UIView *contentView = [self viewWithTag:2333];
    CGRect newFrame = contentView.frame;
    newFrame.origin.y = newFrame.origin.y + newFrame.size.height;
    [UIView animateWithDuration:.4 animations:^{
        view.alpha = 0.0;
        contentView.frame = newFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -----pickView代理方法-----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"选中了一行");
    self.choseItemString = self.dataArray[row];
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UIView *viewa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
//    view.backgroundColor = [UIColor redColor];
//    return viewa;
//}

@end
