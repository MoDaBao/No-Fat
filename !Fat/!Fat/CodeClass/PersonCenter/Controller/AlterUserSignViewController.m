//
//  AlterUserSignViewController.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlterUserSignViewController.h"
#import "AlterUserSignCell.h"

@interface AlterUserSignViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, copy) NSString *sign;


@end

@implementation AlterUserSignViewController

- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.title =
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    titleLabel.text = @"修改个人简介";
    self.navigationItem.titleView = titleLabel;
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(0, 0, 40, 20);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.confirmBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createTableView];
    // Do any additional setup after loading the view.
}
//  确定按钮方法
- (void)confirm {
//    NSLog(@"233333");
//    NSString * token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
//    //    NSString *token = [[UserInfoManager shareInstance] getUserToken];
//    NSString *urlString = [ALTERUSERINFOURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"sign":self.sign} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserSign:self.sign];
            self.passValue(self.sign);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//  返回按钮方法
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----表视图代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return @"2333";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    AlterUserSignCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[AlterUserSignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.passValue = ^(NSString *sign, NSInteger count) {
//            [self confirm:sign];
            self.sign = sign;
            if (count) {
                [self.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else {
                [self.confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
//            self.passValue(sign);
        };
        
    }
    cell.textView.text = self.oldSign;
    cell.wordCount.text = [NSString stringWithFormat:@"%ld",cell.count - [UILabel getWordCountWithTitle:self.oldSign font:cell.textView.font]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
