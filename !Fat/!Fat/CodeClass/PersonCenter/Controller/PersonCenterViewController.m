 //
//  PersonCenterViewController.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "LoginViewController.h"
#import "PersonCenterHeaderView.h"
#import "PersonInfoViewController.h"
#import "MenuItemCell.h"
#import "MyNewsViewController.h"

#define UserViewBGColor [UIColor colorWithRed:58 / 255.0 green:60 / 255.0 blue:71 / 255.0 alpha:1.0]

@interface PersonCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;// 表视图
@property (nonatomic, strong) PersonCenterHeaderView *headerView;// 表视图上的头视图
@property (nonatomic, strong) NSMutableArray *menuArray;// 菜单数组
@property (nonatomic, assign) NSInteger isLogin;// 判断用户是否已经登录


@end

@implementation PersonCenterViewController


#pragma mark -----LazyLoading-----

- (NSMutableArray *)menuArray {
    if (!_menuArray) {
        self.menuArray = [NSMutableArray array];
        [_menuArray addObject:@"我的动态"];
        [_menuArray addObject:@"我的计时器"];
        [_menuArray addObject:@"邀请朋友"];
//        [_menuArray addObject:@""];
//        [_menuArray addObject:@""];
    }
    return _menuArray;
}

//  创建表视图上的头视图
- (void)createHeaderView {
    _headerView = [[PersonCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
//    [self.logout addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.logout addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

//  退出登录
- (void)click {
//    NSLog(@"233333");
    if ([[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        
    } 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确认退出么?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UserInfoManager shareInstance] removeAllUserInfo];// 清除用户的所有信息
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:logoutAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
//    UIPickerView
  
}

//  创建表视图
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self createHeaderView];// 创建表视图上的头视图
    self.tableView.tableHeaderView = self.headerView;
    
    [self.view addSubview:self.tableView];
}


#pragma mark -----视图方法-----

// 当视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBarHidden = YES;
    
    if ([[[UserInfoManager shareInstance] getUserName] isEqualToString:@"游客"] && ![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
//        self.headerView.usernameLabel.text = @"请添加用户名";
        self.headerView.usernameLabel.text = [NSString stringWithFormat:@"!Fat_%@",[[UserInfoManager shareInstance] getUserID]];
    } else {
        self.headerView.usernameLabel.text = [[UserInfoManager shareInstance] getUserName];
    }
    
    if ([[[UserInfoManager shareInstance] getUserGender] isEqualToString:@"1"]) {
        self.headerView.genderImageView.image = [UIImage imageNamed:@"male"];
    } else if ([[[UserInfoManager shareInstance] getUserGender] isEqualToString:@"2"]) {
        self.headerView.genderImageView.image = [UIImage imageNamed:@"female"];
    } else {
        self.headerView.genderImageView.image = [UIImage imageNamed:@"unkowngender"];
    }
    
    // 根据usernameLabel的文字宽度改变genderImageView的frame
    CGFloat width = [UILabel getWidthWithTitle:self.headerView.usernameLabel.text font:self.headerView.usernameLabel.font];
    CGRect newImageFrame = self.headerView.genderImageView.frame;
    newImageFrame.origin.x = kScreenWidth * 0.5 + width * 0.5;
    self.headerView.genderImageView.frame = newImageFrame;
    
//    self.headerView.userNAGView.usernameLabel.text = [[UserInfoManager shareInstance] getUserName];
//    CGFloat width = [UILabel getWidthWithTitle:[[UserInfoManager shareInstance] getUserName] font:self.headerView.userNAGView.usernameLabel.font];
//    CGRect newFrame = self.headerView.userNAGView.frame;
//    newFrame.size.width = width + 12;
//    self.headerView.userNAGView.frame = newFrame;
    
    NSArray *array = [[[UserInfoManager shareInstance] gettUserAvatar] componentsSeparatedByString:@"/"];
    if (![array[0] isEqualToString:@" "]) {// 如果有头像则加载
        [self.headerView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640", array[0], array[1]]]];
    } else {
        self.headerView.headImageView.image = [UIImage imageNamed:@"head"];
    }
    
    // 如果登录则显示个人资料并且menuArray数组中
    if (![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "] && ![self.menuArray[0] isEqualToString:@"个人资料"]) {
        [self.menuArray insertObject:@"个人资料" atIndex:0];
        [self.tableView reloadData];
    } else if ([[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "] && [self.menuArray[0] isEqualToString:@"个人资料"]) {
        [self.menuArray removeObjectAtIndex:0];
        [self.tableView reloadData];
    }
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 20, 20);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithCustomView:loginBtn];
    self.navigationItem.leftBarButtonItem = loginItem;
    
    // 如果未登录显示登录按钮,不显示退出按钮
    if ([[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        loginBtn.hidden = NO;
        self.headerView.logout.hidden = YES;
    } else {
        loginBtn.hidden = YES;
        self.headerView.logout.hidden = NO;
    }
    
    

    // 获取粉丝数量
    [self getFansCount];
}

//  弹出登录页面
- (void)login {
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNaVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    
    
    // 测试 登录
    if ([[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    }
    
    
    
    [self createTableView];// 创建表视图
    
    
}

//  获取粉丝数量
- (void)getFansCount {
    if (![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",GETFANSCOUNTURL, [[UserInfoManager shareInstance] getUserID]];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *userStatsDic = responseObject[@"userStats"][0];
            NSNumber *fansCount = userStatsDic[@"fansCount"];
            NSNumber *followCount = userStatsDic[@"followCount"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headerView.fansCountLabel.text = [NSString stringWithFormat:@"%d粉丝",fansCount.intValue];
                self.headerView.focusCountLabel.text = [NSString stringWithFormat:@"%d关注",followCount.intValue];
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
        }];
        
    }
}


#pragma mark -----表视图代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 50;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.messageLabel.text = self.menuArray[indexPath.row];
//    CGFloat width = [UILabel getWidthWithTitle:cell.messageLabel.text font:cell.messageLabel.font];
//    CGRect newFrame = cell.messageLabel.frame;
//    newFrame.size.width = width;
//    cell.messageLabel.frame = newFrame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menuArray[indexPath.row] isEqualToString:@"个人资料"]) {
        PersonInfoViewController *personInfoVC = [[PersonInfoViewController alloc] init];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    } else if ([self.menuArray[indexPath.row] isEqualToString:@"我的动态"]) {
        if (![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
            MyNewsViewController *newsVC = [[MyNewsViewController alloc] init];
            [self.navigationController pushViewController:newsVC animated:YES];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } else if ([self.menuArray[indexPath.row] isEqualToString:@"我的计时器"]) {
        
    } else if ([self.menuArray[indexPath.row] isEqualToString:@"邀请朋友"]) {
        if (![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
