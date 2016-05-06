//
//  MOCustomDatePickerView.m
//  test
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MOCustomDatePickerView.h"
#import "UILabel+LabelHeightAndWidth.h"

@interface MOCustomDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIDatePicker *datePiker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *minuteArray;//分
@property (nonatomic, strong) NSMutableArray *secondArray;// 秒
//@property (nonatomic, strong)  *<#name#>;
@property (nonatomic, copy) NSString *second;
@property (nonatomic, copy) NSString *minute;

@end
@implementation MOCustomDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        [_dataArray addObject:self.minuteArray];
        [_dataArray addObject:self.secondArray];
    }
    return _dataArray;
}

- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        self.minuteArray = [NSMutableArray array];
        for (int i = 0; i < 30; i ++) {
            [_minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _minuteArray;
}

- (NSMutableArray *)secondArray {
    if (!_secondArray) {
        self.secondArray = [NSMutableArray array];
        for (int i = 1; i < 60; i++) {
            [_secondArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _secondArray;
}


//  自定义初始化方法
+ (MOCustomDatePickerView *)cretaCustomPickerViewWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSMutableArray *)dataArray {
MOCustomDatePickerView *custom = [[MOCustomDatePickerView alloc] initWithFrame:frame dataArray:dataArray];
    custom.titleLabel.text = title;
    CGFloat width = [UILabel getWidthWithTitle:title font:custom.titleLabel.font];
    custom.titleLabel.frame = CGRectMake(kScreenWidth * 0.5 - width * 0.5, 0, width, 30);
    return custom;
}

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray {
    if (self = [super initWithFrame:frame]) {
//        self.dataArray = [NSMutableArray array];
//        for (NSString *item in dataArray) {
//            [self.dataArray addObject:item];
//        }
        
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
        
        // 分钟标签
        UILabel *minuteLabel = [[UILabel alloc] init];
        minuteLabel.text = @"分钟";
        minuteLabel.width = [UILabel getWidthWithTitle:minuteLabel.text font:minuteLabel.font];
        minuteLabel.x = kScreenWidth * .25 + [UILabel getWidthWithTitle:@"0" font:minuteLabel.font] + 10;
        minuteLabel.height = [UILabel getHeightByWidth:minuteLabel.width title:minuteLabel.text font:minuteLabel.font];
        minuteLabel.y = self.pickerView.height * 0.5 - minuteLabel.height * 0.5;
        [self.pickerView addSubview:minuteLabel];
        
        //秒标签
        UILabel *secondLabel = [[UILabel alloc] init];
        secondLabel.text = @"秒";
        secondLabel.width = [UILabel getWidthWithTitle:secondLabel.text font:secondLabel.font];
        secondLabel.x = kScreenWidth * .75 + [UILabel getWidthWithTitle:@"0" font:minuteLabel.font] + 10;
        secondLabel.height = [UILabel getHeightByWidth:secondLabel.width title:secondLabel.text font:secondLabel.font];
        secondLabel.y = self.pickerView.height * 0.5 - secondLabel.height * 0.5;
        [self.pickerView addSubview:secondLabel];
        
//        self.datePiker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, contentHeight - pickerHeight, kScreenWidth, pickerHeight)];
//        self.datePiker.datePickerMode = UIDatePickerModeCountDownTimer;
//        self.datePiker.backgroundColor = [UIColor whiteColor];
//        [self.datePiker addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
//        [contentView addSubview:self.datePiker];
        
        CGRect newFrame = contentView.frame;
        newFrame.origin.y = newFrame.origin.y - contentHeight;
        [UIView animateWithDuration:.4 animations:^{
            backgroundView.alpha = 0.2;
            contentView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
        
        self.minute = @"0";
        self.second = @"1";
    }
    return self;
}

//  确定按钮方法
- (void)confirm {
//    if (self.choseItemString) {
//        self.click(self.choseItemString);
//    } else {
//        self.click([NSString stringWithFormat:@"1"]);
//    }
    
//    if (self.second && self.minute) {
//        
//    } else if (self.second && !self.minute) {
//        
//    } else if (!self.second && self.minute) {
//        
//    }
    int minute = [self.minute intValue];
    int second = [self.second intValue];
    self.click([NSString stringWithFormat:@"%d",minute * 60 + second]);
    
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


- (void)changeValue:(UIDatePicker *)picker {
    NSTimeInterval time = picker.countDownDuration;
    self.choseItemString = [NSString stringWithFormat:@"%f",time];
}


#pragma mark -----pickerView代理方法-----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray[component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = self.dataArray[component][row];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"选中了一行");
    NSLog(@"%ld, %ld",row,component);
//    NSString *minute = self.dataArray[component][row];
//    NSString *second = self.dataArray[]
//    self.choseItemString = [NSString stringWithFormat:@"%d",]
    if (component == 0) {
        self.minute = self.dataArray[component][row];
    } else {
        self.second = self.dataArray[component][row];
    }
}





@end
