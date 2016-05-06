//
//  AlterTitleViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlterTitleViewController.h"


@interface AlterTitleViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIImageView  *iconImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIPickerView *imagePickerView;
@property (nonatomic, strong) NSMutableArray *iconArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlterTitleViewController

- (NSMutableArray *)iconArray {
    if (!_iconArray) {
//        _iconArray = @{@"跑步":@"runGray", @"上下蹲":@"squatGray", @"体操":@"gymGray"};
        self.iconArray = [NSMutableArray array];
        [_iconArray addObject:@{@"跑步":@"runGray"}];
        [_iconArray addObject:@{@"上下蹲":@"squatGray"}];
        [_iconArray addObject:@{@"体操":@"gymGray"}];
    }
    return _iconArray;
}

- (NSMutableArray *)colorArray {
    if (!_colorArray) {
//        _colorArray = @{@"粉色":@"kPink", @"灰色":@"kGray", @"绿色":@"kGreen", @"蓝色":@"kBlue"};
        self.colorArray = [NSMutableArray array];
        [_colorArray addObject:@{@"粉色":@"kPink"}];
        [_colorArray addObject:@{@"灰色":@"kGray"}];
        [_colorArray addObject:@{@"绿色":@"kGreen"}];
        [_colorArray addObject:@{@"蓝色":@"kBlue"}];
    }
    return _colorArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        [_dataArray addObject:self.iconArray];
        [_dataArray addObject:self.colorArray];
    }
    return _dataArray;
}

// 创建视图
- (void)createView {
    CGFloat margin = 10;
    CGFloat headViewHeight = 40;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + 10, kScreenWidth, headViewHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.iconImageView.centerY = headViewHeight * .5;
    self.iconImageView.x = margin;
    self.iconImageView.image = [UIImage imageNamed:self.detailItemModel.titleicon];
    self.iconImageView.layer.cornerRadius = self.iconImageView.width * 0.25;
    [ChangeColorManager changColorWithImageView:self.iconImageView color:self.detailItemModel.titlecolor];// 设置背景色
    [headView addSubview:self.iconImageView];
    
    CGFloat textFieldHeight = self.iconImageView.height;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(margin * 1.5 + self.iconImageView.width, headViewHeight * 0.5 - textFieldHeight * 0.5, kScreenWidth - margin * 2 - margin * .5 - self.iconImageView.width, textFieldHeight)];
    //    self.textField.centerY = headViewHeight * 0.5;
    //    self.textField.width = kScreenWidth - margin * 2 - margin * .5;
    //    self.textField.height = headViewHeight * 2 / 3.0;
    //    self.textField.x = margin * 1.5 + self.iconImageView.width;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.text = self.detailItemModel.title;
    self.textField.font = [UIFont systemFontOfSize:14];
    [headView addSubview:self.textField];
    
    [self.view addSubview:headView];
    
    CGFloat marginTop = 20;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"修改颜色和图标";
    label.font = [UIFont systemFontOfSize:12];
    label.x = margin;
    label.width = [UILabel getWidthWithTitle:label.text font:label.font];
    label.y = headView.y + headViewHeight + marginTop;
    label.height = [UILabel getHeightByWidth:label.width title:label.text font:label.font];
    [self.view addSubview:label];
    
    self.imagePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, label.y + label.height, kScreenWidth, 200)];
    self.imagePickerView.delegate = self;
    self.imagePickerView.dataSource = self;
    self.imagePickerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imagePickerView];
}

// 创建按钮
- (void)createBtn {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)back {
    self.passValue(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"修改计时器";
    
    [self createView];// 创建视图
    [self createBtn];// 创建按钮
}


#pragma mark -----pickerView代理方法-----

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger count = self.dataArray.count;
    return count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = [self.dataArray[component] count];
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 20)];
//    returnView.backgroundColor = [UIColor orangeColor];
    CGFloat width = 25;
    CGFloat height = width;
    CGFloat margin = 10;
    CGFloat totalwidth = [UILabel getWidthWithTitle:@"跑步" font:[UIFont systemFontOfSize:14]] + margin + width;
    CGFloat imageX = kScreenWidth * 0.25 - totalwidth * 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, returnView.height * 0.5 - height * 0.5, width, height)];
    imageView.layer.cornerRadius = width * 0.25;
    // 取出数据源
    NSDictionary *dic = self.dataArray[component][row];
    if (component == 0) {
        imageView.image = [UIImage imageNamed:dic.allValues[0]];
    } else {
//        [self assignmentWithImageView:imageView color:dic.allValues[0]];
        [ChangeColorManager changColorWithImageView:imageView color:dic.allValues[0]];
    }
    [returnView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageX + margin + width, 0, 50, returnView.height)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = dic.allKeys[0];
    [returnView addSubview:label];
    
    
    return returnView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
