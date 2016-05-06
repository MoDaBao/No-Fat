//
//  StepDetailViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "StepDetailViewController.h"
#import "MenuItemCell.h"
#import "MOCustomDatePickerView.h"
#import "StepNameViewController.h"
#import "SelectColorViewController.h"

@interface StepDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;// 标题颜色数据源
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *minuteArray;//分
@property (nonatomic, strong) NSMutableArray *secondArray;// 秒
@property (nonatomic, strong) NSMutableArray *dataArray;// 选择器数据源
@property (nonatomic, copy) NSString *second;
@property (nonatomic, copy) NSString *minute;

@end

@implementation StepDetailViewController


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

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        self.itemArray = [NSMutableArray array];
        NSArray *array = [self.step componentsSeparatedByString:@"&"];
        [_itemArray addObject:@{@"标题":array[1]}];
        [_itemArray addObject:@{@"颜色":array[0]}];
        [_itemArray addObject:@{@"时间":array[2]}];
        NSString *time = array[2];
        NSArray *timearr = [time componentsSeparatedByString:@":"];
        self.minute = [timearr firstObject];
        self.second = [timearr lastObject];
    }
    return _itemArray;
}

- (void)createTableView {
    CGFloat margin = 30;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight + margin, kScreenWidth, 40 * (self.itemArray.count - 1)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)createPickerView {
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.tableView.y + self.tableView.height + 10, kScreenWidth, 150)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"步骤详情";
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
    [self createPickerView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

- (void)back {
    NSString *color = [self.itemArray[1] allValues].firstObject;
    NSString *title = [self.itemArray[0] allValues].firstObject;
    int minute = [self.minute intValue];
    int second = [self.second intValue];
    NSString *step = [NSString stringWithFormat:@"%@&%@&%02d:%02d",color, title, minute, second];
    self.backBlock(step);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----表视图代理-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *dic = self.itemArray[indexPath.row];
    cell.messageLabel.text = dic.allKeys.firstObject;
    NSString *str = [ChangeColorManager changColorNameWithColor:dic.allValues.firstObject];
    if (str) {
        cell.detailMessageLabel.text= str;
    } else {
        cell.detailMessageLabel.text = dic.allValues.firstObject;
    }
    cell.detailMessageLabel.width = [UILabel getWidthWithTitle:cell.detailMessageLabel.text font:cell.detailMessageLabel.font];
    cell.detailMessageLabel.x = cell.rightImageView.x - cell.detailMessageLabel.width;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        StepNameViewController *stepnameVC = [[StepNameViewController alloc] init];
        stepnameVC.stepName = [self.itemArray[indexPath.row] allValues].firstObject;
        stepnameVC.passValue = ^(NSString *stepName) {
            self.itemArray[indexPath.row] = @{@"标题":stepName};
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:stepnameVC animated:YES];
    } else {
        SelectColorViewController *selectcolorVC = [[SelectColorViewController alloc] init];
        selectcolorVC.color = [self.itemArray[indexPath.row] allValues].firstObject;
        selectcolorVC.passColor = ^(NSString *color) {
            self.itemArray[indexPath.row] = @{@"颜色":color};
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:selectcolorVC animated:YES];
    }
}


#pragma mark -----pickerView代理-----

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
    if (component == 0) {
        self.minute = self.dataArray[component][row];
    } else {
        self.second = self.dataArray[component][row];
    }
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
