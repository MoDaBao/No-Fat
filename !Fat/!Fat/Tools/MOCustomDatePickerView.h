//
//  MOCustomDatePickerView.h
//  test
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Click)(NSString *);
@interface MOCustomDatePickerView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;// 取消按钮
@property (nonatomic, strong) UIButton *confirmBtn;// 确定按钮
@property (nonatomic, strong) UILabel *titleLabel;// 标题
@property (nonatomic, copy) Click click;

@property (nonatomic, copy) NSString *choseItemString;
@property (nonatomic, strong) NSMutableArray *dataArray;


//  自定义初始化方法
+ (MOCustomDatePickerView *)cretaCustomPickerViewWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSMutableArray *)dataArray;
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray;

@end
