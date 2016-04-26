//
//  MyNewsViewController.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MyNewsViewController.h"
#import "MyNewsCell.h"
#import "MyNewsModel.h"

@interface MyNewsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *newsItemArray;

@end

@implementation MyNewsViewController

- (NSMutableArray *)newsItemArray {
    if (!_newsItemArray) {
        self.newsItemArray = [NSMutableArray array];
    }
    return _newsItemArray;
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
}

- (void)requestData {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *urlString = [GETUSERNEWSURL stringByAppendingString:[NSString stringWithFormat:@"&user_id=%@",[[UserInfoManager shareInstance] getUserID]]];
    [session GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            NSArray *dataArray = responseObject[@"feeds"];
            for (NSDictionary *dic in dataArray) {
                MyNewsModel *model = [[MyNewsModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.newsItemArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = @"我的动态";
    self.navigationItem.titleView = label;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createTableView];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsItemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat width = [UILabel getHeightByWidth:<#(CGFloat)#> title:<#(NSString *)#> font:<#(UIFont *)#>]
    CGFloat contentMargin = 20;
    CGFloat leftMargin = 60;
    MyNewsModel *model = self.newsItemArray[indexPath.row];
     CGFloat contentHeight = [UILabel getHeightByWidth:kScreenWidth - contentMargin - leftMargin title:model.content font:[UIFont systemFontOfSize:13]];
    if (model.image) {
        return 70 + contentHeight + (kScreenWidth - 120);
    } else {
        return 70 + contentHeight;
    }
//    return 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    MyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MyNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    MyNewsModel *model = self.newsItemArray[indexPath.row];
    [cell setDataWithModel:model];
    
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
