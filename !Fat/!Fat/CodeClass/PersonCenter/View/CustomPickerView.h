//
//  CustomPickerView.h
//  test
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSString *);
@interface CustomPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *cancelBtn;// 取消按钮
@property (nonatomic, strong) UIButton *confirmBtn;// 确定按钮
@property (nonatomic, strong) UILabel *titleLabel;// 标题
@property (nonatomic, copy) ClickBlock click;

@property (nonatomic, copy) NSString *choseItemString;
@property (nonatomic, strong) NSMutableArray *dataArray;

//  自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray;
//  便利构造器
+ (CustomPickerView *)cretaCustomPickerViewWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSMutableArray *)dataArray;

@end
