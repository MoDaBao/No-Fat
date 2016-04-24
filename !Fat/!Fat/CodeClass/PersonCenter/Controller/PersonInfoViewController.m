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
    if (!_baseInfoArray) {
        self.baseInfoArray = [NSMutableArray array];
        [_baseInfoArray addObject:@{@"昵称":[[UserInfoManager shareInstance] getUserName]}];
        [_baseInfoArray addObject:@{@"性别":[[UserInfoManager shareInstance] getUserGender]}];
        [_baseInfoArray addObject:@{@"个人简介":[[UserInfoManager shareInstance] getUserSign]}];
//        [_baseInfoArray addObject:@{@"注册时间":[[UserInfoManager shareInstance] getUserCreateTime]}];
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

- (NSMutableArray *)healthInfoArray {
    if (!_healthInfoArray) {// 将用户的信息保存在数组中方便读取展示
        self.healthInfoArray = [NSMutableArray array];
        [_healthInfoArray addObject:@{@"身高":[[UserInfoManager shareInstance] getUserHeight]}];
        [_healthInfoArray addObject:@{@"体重":[[UserInfoManager shareInstance] getUserWeight]}];
        CGFloat height = [[[UserInfoManager shareInstance] getUserHeight] floatValue] * 0.01;
        CGFloat weight = [[[UserInfoManager shareInstance] getUserWeight] floatValue];
        CGFloat BMI = weight / height / height;
        [_healthInfoArray addObject:@{@"BMI(正常:18.5-24.99)":[NSString stringWithFormat:@"%.2lf",BMI]}];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    } else {
        cell.detailMessageLabel.text = [dic.allValues firstObject];
    }
//    else if ([cell.messageLabel.text isEqualToString:@"注册时间"]) {
//        double time = [[dic.allValues firstObject] doubleValue] / 24.0;
////        CGFloat year = time /
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
//        //将一个日期对象转化为字符串对象
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        //设置日期与字符串互转的格式
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        //将日期转化为字符串
//        NSString *dateStr = [formatter stringFromDate:date];
//        cell.detailMessageLabel.text = dateStr;
//    }
    
    
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
    if (!indexPath.section && !indexPath.row) {// 昵称
        [self selectUserNameCellWith:indexPath];
    } else if (!indexPath.section && indexPath.row == 1) {// 性别
        [self selectUserGenderCellWith:indexPath];
    } else if (!indexPath.section && indexPath.row == 2) {// 个人简介
        [self selectUserSignCellWith:indexPath];
    }
}

//  昵称单元格方法
- (void)selectUserNameCellWith:(NSIndexPath *)indexPath {
    AlterUserNameViewController *alterVC = [[AlterUserNameViewController alloc] init];
    alterVC.oldUserName = self.baseInfoArray[indexPath.row][@"昵称"];
    alterVC.passValue = ^(NSString *username) {
        self.baseInfoArray[indexPath.row] = @{@"昵称":username};
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:alterVC animated:YES];
}

//  性别单元格方法
- (void)selectUserGenderCellWith:(NSIndexPath *)indexPath {
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
    NSString * token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    //    NSString *token = [[UserInfoManager shareInstance] getUserToken];
    NSString *urlString = [ALTERUSERINFOURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
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
- (void)selectUserSignCellWith:(NSIndexPath *)indexPath {
    AlterUserSignViewController *alterSignVC = [[AlterUserSignViewController alloc] init];
    alterSignVC.passValue = ^(NSString *sign) {
        self.baseInfoArray[indexPath.row] = @{@"个人简介":sign};
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:alterSignVC animated:YES];
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
