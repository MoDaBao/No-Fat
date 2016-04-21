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

#define UserViewBGColor [UIColor colorWithRed:58 / 255.0 green:60 / 255.0 blue:71 / 255.0 alpha:1.0]

@interface PersonCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;// 表视图
@property (nonatomic, strong) PersonCenterHeaderView *headerView;// 表视图上的头视图
@property (nonatomic, strong) NSMutableArray *menuArray;// 菜单数组
@property (nonatomic, assign) NSInteger isLogin;// 判断用户是否已经登录


@end

@implementation PersonCenterViewController

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

// 当视图即将出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.headerView.usernameLabel.text = [[UserInfoManager shareInstance] getUserName];
    CGFloat width = [UILabel getWidthWithTitle:[[UserInfoManager shareInstance] getUserName] font:self.headerView.usernameLabel.font];
    CGRect newFrame = self.headerView.usernameLabel.frame;
    newFrame.size.width = width;
    CGRect newImageFrame = self.headerView.genderImageView.frame;
    newImageFrame.origin.x = kScreenWidth * 0.5 + width * 0.5;
    self.headerView.genderImageView.frame = newImageFrame;
    
    
    
//    self.headerView.userNAGView.usernameLabel.text = [[UserInfoManager shareInstance] getUserName];
//    CGFloat width = [UILabel getWidthWithTitle:[[UserInfoManager shareInstance] getUserName] font:self.headerView.userNAGView.usernameLabel.font];
//    CGRect newFrame = self.headerView.userNAGView.frame;
//    newFrame.size.width = width + 12;
//    self.headerView.userNAGView.frame = newFrame;
    NSArray *array = [[[UserInfoManager shareInstance] gettUserAvatar] componentsSeparatedByString:@"/"];
    [self.headerView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@.fit-time.cn/%@@!640", array[0], array[1]]]];
    
    // 如果登录
    if (![[[UserInfoManager shareInstance] getUserID] isEqualToString:@" "]) {
        [self.menuArray insertObject:@"个人资料" atIndex:0];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    // 测试
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNaVC animated:YES completion:nil];
    
    
    [self createTableView];// 创建表视图
    
    [self getFansCount];
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
        
    } else if ([self.menuArray[indexPath.row] isEqualToString:@"我的计时器"]) {
        
    } else if ([self.menuArray[indexPath.row] isEqualToString:@"邀请朋友"]) {
        
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
