//
//  PersonInfoViewController.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "MenuItemCell.h"
#import "AlterUserNameViewController.h"
#import "AlterUserSignViewController.h"
#import "CustomPickerView.h"
#import "AppDelegate.h"

@interface PersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *dataDic;// 分区字典 ps:个人觉得用数组好像更方便
@property (nonatomic, strong) NSMutableArray *baseInfoArray;// 基础信息数据源
@property (nonatomic, strong) NSMutableArray *healthInfoArray;// 健康信息数据源
//@property (nonatomic, strong) NSMutableDictionary *userInfoDic;
//@property (nonatomic, strong) NSMutableDictionary *baseInfoDic;
//@property (nonatomic, strong) NSMutableDictionary *healthInfoDic;

@end

@implementation PersonInfoViewController

//- (NSMutableDictionary *)userInfoDic {
//    if (!_userInfoDic) {
//        self.userInfoDic = [NSMutableDictionary dictionary];
//        for (NSString *key in self.baseInfoArray) {
//            _userInfoDic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>
//        }
//    }
//    return _userInfoDic;
//}

- (NSMutableArray *)baseInfoArray {
    if (!_baseInfoArray) {// 将用户的信息保存在数组中方便读取展示
        self.baseInfoArray = [NSMutableArray array];
        if ([[[UserInfoManager shareInstance] getUserName] isEqualToString:@"游客"]) {
            [_baseInfoArray addObject:@{@"昵称":[NSString stringWithFormat:@"!Fat_%@",[[UserInfoManager shareInstance] getUserID]]}];
        } else {
            [_baseInfoArray addObject:@{@"昵称":[[UserInfoManager shareInstance] getUserName]}];
        }
        
        [_baseInfoArray addObject:@{@"性别":[[UserInfoManager shareInstance] getUserGender]}];
        [_baseInfoArray addObject:@{@"个人简介":[[UserInfoManager shareInstance] getUserSign]}];
        [_baseInfoArray addObject:@{@"注册时间":[[UserInfoManager shareInstance] getUserCreateTime]}];
        [_baseInfoArray addObject:@{@"用户ID":[[UserInfoManager shareInstance] getUserID]}];
    }
    return _baseInfoArray;
}

//- (NSMutableDictionary *)baseInfoDic {
//    if (!_baseInfoDic) {
//        self.baseInfoDic = [NSMutableDictionary dictionary];
//        _baseInfoDic.
//    }
//    return _baseInfoDic;
//}
//
//- (NSMutableDictionary *)healthInfoDic {
//    if (!_healthInfoDic) {
//        self.healthInfoDic = [NSMutableDictionary dictionary];
//    }
//    return _healthInfoDic;
//}

//  判断能否计算BMI值
- (void)alterBMI {
    if ([[[UserInfoManager shareInstance] getUserHeight] isEqualToString:@" "] || [[[UserInfoManager shareInstance] getUserWeight] isEqualToString:@" "]) {
        [_healthInfoArray addObject:@{@"BMI(正常:18.5-24.99)":@" "}];
    } else {
        CGFloat height = [[[UserInfoManager shareInstance] getUserHeight] floatValue] * 0.01;
        CGFloat weight = [[[UserInfoManager shareInstance] getUserWeight] floatValue];
        CGFloat BMI = weight / height / height;
        [_healthInfoArray addObject:@{@"BMI(正常:18.5-24.99)":[NSString stringWithFormat:@"%.2lf",BMI]}];
    }
}

- (NSMutableArray *)healthInfoArray {
    if (!_healthInfoArray) {// 将用户的信息保存在数组中方便读取展示
        self.healthInfoArray = [NSMutableArray array];
        [_healthInfoArray addObject:@{@"身高":[[UserInfoManager shareInstance] getUserHeight]}];
        [_healthInfoArray addObject:@{@"体重":[[UserInfoManager shareInstance] getUserWeight]}];
        
//        if ([[[UserInfoManager shareInstance] getUserHeight] isEqualToString:@" "] || [[[UserInfoManager shareInstance] getUserWeight] isEqualToString:@" "]) {
//            [_healthInfoArray addObject:@{@"BMI(正常:18.5-24.99)":@" "}];
//        } else {
//            CGFloat height = [[[UserInfoManager shareInstance] getUserHeight] floatValue] * 0.01;
//            CGFloat weight = [[[UserInfoManager shareInstance] getUserWeight] floatValue];
//            CGFloat BMI = weight / height / height;
//            [_healthInfoArray addObject:@{@"BMI(正常:18.5-24.99)":[NSString stringWithFormat:@"%.2lf",BMI]}];
//        }
        [self alterBMI];
        
        [_healthInfoArray addObject:@{@"训练目的":[[UserInfoManager shareInstance] getUserTrainGoal]}];
        [_healthInfoArray addObject:@{@"训练基础":[[UserInfoManager shareInstance] getUserTrainBase]}];
        [_healthInfoArray addObject:@{@"训练频率":[[UserInfoManager shareInstance] getUserTrainFrequency]}];
    }
    return _healthInfoArray;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionary];
        [_dataDic setObject:self.baseInfoArray forKey:@"基础信息"];
        [_dataDic setObject:self.healthInfoArray forKey:@"健康信息"];
    }
    return _dataDic;
}

//  创建表视图
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
//    [UIView animateWithDuration:0.5 animations:^{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    }];
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
//    self.navigationItem.title = @"个人资料";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = @"个人资料";
    self.navigationItem.titleView = label;
    
//    self.navigationController.navigationBarHidden = NO;
    // 设置导航条的返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    // 创建表视图
    [self createTableView];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----表视图代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDic.allValues[section] count];
}
//  分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataDic.allKeys[section];
}
//  头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
//  脚视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;// 设置0无效
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // 获取当前单元格的数据来源
    NSDictionary *dic = self.dataDic.allValues[indexPath.section][indexPath.row];
    cell.messageLabel.text = [dic.allKeys firstObject];
    
    if ([cell.messageLabel.text isEqualToString:@"性别"]) {
        if ([dic[@"性别"] isEqualToString:@"1"]) {
            cell.detailMessageLabel.text = @"男";
        } else {
            cell.detailMessageLabel.text = @"女";
        }
    } else if ([cell.messageLabel.text isEqualToString:@"注册时间"]) {
        double time = [[dic.allValues firstObject] doubleValue] / 1000;
        //        CGFloat year = time /
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        //将一个日期对象转化为字符串对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置日期与字符串互转的格式
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //将日期转化为字符串
        NSString *dateStr = [formatter stringFromDate:date];
        cell.detailMessageLabel.text = dateStr;
    } else {
        cell.detailMessageLabel.text = [dic.allValues firstObject];
    }
    
    
    // 使detailMessageLabel自适应宽度
    CGFloat width = [UILabel getWidthWithTitle:cell.detailMessageLabel.text font:cell.detailMessageLabel.font];
    width = width > (2 / 3.0 * kScreenWidth) ? (2 / 3.0 * kScreenWidth) : width;
    CGRect newFrame = cell.detailMessageLabel.frame;
    newFrame.size.width = width;
    newFrame.origin.x = kScreenWidth - width - 25;
    cell.detailMessageLabel.frame = newFrame;
    
    if ([cell.messageLabel.text isEqualToString:@"注册时间"] || [cell.messageLabel.text isEqualToString:@"用户ID"] || [cell.messageLabel.text isEqualToString:@"BMI(正常:18.5-24.99)"]) {
        cell.rightImageView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
//  单击单元格触发的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.section && !indexPath.row) {// 昵称
        [self selectUserNameCellWithindexPath:indexPath];
    } else if (!indexPath.section && indexPath.row == 1) {// 性别
        [self selectUserGenderCellWithindexPath:indexPath];
    } else if (!indexPath.section && indexPath.row == 2) {// 个人简介
        [self selectUserSignCellWithindexPath:indexPath];
    } else if (indexPath.section == 1 && indexPath.row == 0) {// 身高
        [self selectUserHeightCellWithindexPath:indexPath];
    } else if (indexPath.section == 1 && indexPath.row == 1) {// 体重
        [self selectUserWeightCellWithindexPath:indexPath];
    } else if (indexPath.section == 1 && indexPath.row == 3) {// 训练目的
        [self selectUserTrainGoalWithindexPath:indexPath];
    } else if (indexPath.section == 1 && indexPath.row == 4) {// 训练基础
        [self selectUserTrainBaseWithindexPath:indexPath];
    } else if (indexPath.section == 1 && indexPath.row == 5) {// 训练频率
        [self selectUserTrainFrequencyWithindexPath:indexPath];
    }
}

//  昵称单元格方法
- (void)selectUserNameCellWithindexPath:(NSIndexPath *)indexPath {
    AlterUserNameViewController *alterVC = [[AlterUserNameViewController alloc] init];
    alterVC.oldUserName = self.baseInfoArray[indexPath.row][@"昵称"];
    alterVC.passValue = ^(NSString *username) {
        self.baseInfoArray[indexPath.row] = @{@"昵称":username};
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:alterVC animated:YES];
}

//  性别单元格方法
- (void)selectUserGenderCellWithindexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *male = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.baseInfoArray[1] = @{@"性别":@"1"};
//        [[UserInfoManager shareInstance] saveUserGender:@1];
        [self alterUserGender:@1];// 修改性别
        
    }];
    UIAlertAction *female = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.baseInfoArray[1] = @{@"性别":@"2"};
//        [[UserInfoManager shareInstance] saveUserGender:@2];
        [self alterUserGender:@2];// 修改性别
//        [self.tableView reloadData];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:male];
    [alert addAction:female];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//  修改性别
- (void)alterUserGender:(NSNumber *)gender {
//    NSString * token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
//    //    NSString *token = [[UserInfoManager shareInstance] getUserToken];
//    NSString *urlString = [ALTERUSERINFOURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"gender":[gender stringValue]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
//            NSString *aa = [gender stringValue];
            self.baseInfoArray[1] = @{@"性别":[gender stringValue]};
            [[UserInfoManager shareInstance] saveUserGender:gender];
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//  个人简介单元格方法
- (void)selectUserSignCellWithindexPath:(NSIndexPath *)indexPath {
    AlterUserSignViewController *alterSignVC = [[AlterUserSignViewController alloc] init];
    alterSignVC.oldSign = self.baseInfoArray[indexPath.row][@"个人简介"];
    alterSignVC.passValue = ^(NSString *sign) {
        self.baseInfoArray[indexPath.row] = @{@"个人简介":sign};
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:alterSignVC animated:YES];
}

//  身高单元格方法
- (void)selectUserHeightCellWithindexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 110; i <= 230; i ++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    CustomPickerView *pickerView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"选择身高(cm)" dataArray:array];
    pickerView.click = ^(NSString *height) {
        // 修改身高
        [self alterUserHeight:height];
    };
//    [self.view addSubview:pickerView];
//    [self.view bringSubviewToFront:pickerView];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:pickerView];
    
    
}

//  修改身高
- (void)alterUserHeight:(NSString *)height {
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"height":height} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserHeight:height];
            self.healthInfoArray[0] = @{@"身高":height};
                // 判断要不要修改BMI值
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  体重单元格方法
- (void)selectUserWeightCellWithindexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 35; i <= 150; i ++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    CustomPickerView *pickerView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"选择体重(kg)" dataArray:array];
    pickerView.click = ^(NSString *weight) {
        // 修改体重
        [self alterUserWeight:weight];
    };
    //    [self.view addSubview:pickerView];
    //    [self.view bringSubviewToFront:pickerView];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:pickerView];
}

//  修改体重
- (void)alterUserWeight:(NSString *)weight {
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"weight":weight} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserWeight:weight];
            self.healthInfoArray[1] = @{@"体重":weight};
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  训练目的单元格
- (void)selectUserTrainGoalWithindexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"减脂"];
    [array addObject:@"增肌"];
    [array addObject:@"塑形"];
    CustomPickerView *pickerView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"训练目的" dataArray:array];
    pickerView.click = ^(NSString *goal) {
        // 修改训练目的
        [self alterUserTrainGoal:goal];
    };
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:pickerView];
}
//  修改训练目的
- (void)alterUserTrainGoal:(NSString *)goal {
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"train_goal":goal} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserTrainGoal:goal];
            self.healthInfoArray[3] = @{@"训练目的":goal};
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  训练基础单元格
- (void)selectUserTrainBaseWithindexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"小白，从未训练"];
    [array addObject:@"初学者"];
    [array addObject:@"进级者"];
    [array addObject:@"运动达人"];
    CustomPickerView *pickerView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"训练基础" dataArray:array];
    pickerView.click = ^(NSString *base) {
        // 修改训练基础
        [self alterUserTrainBase:base];
    };
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:pickerView];
}
//  修改训练基础
- (void)alterUserTrainBase:(NSString *)base {
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"train_base":base} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserTrainBase:base];
            self.healthInfoArray[4] = @{@"训练基础":base};
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  训练频率单元格
- (void)selectUserTrainFrequencyWithindexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"很少锻炼"];
    [array addObject:@"每周1-2次"];
    [array addObject:@"每周3-4次"];
    [array addObject:@"每周5-7次"];
    [array addObject:@"非常活跃和高强度"];
    CustomPickerView *pickerView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"训练频率" dataArray:array];
    pickerView.click = ^(NSString *frequency) {
        // 修改训练基础
        [self alterUserTrainFrequency:frequency];
    };
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:pickerView];
}
//  修改训练频率
- (void)alterUserTrainFrequency:(NSString *)frequency {
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"train_frequency":frequency} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserTrainFrequency:frequency];
            self.healthInfoArray[5] = @{@"训练频率":frequency};
            [self.tableView reloadData];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
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
