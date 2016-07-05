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
#import "AppDelegate.h"

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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}

- (void)requestData {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *urlString = [GETUSERNEWSURL stringByAppendingString:[NSString stringWithFormat:@"&user_id=%@&token=%@",[[UserInfoManager shareInstance] getUserID], [NSString GetEncodeWithToken]]];
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
                if (self.newsItemArray.count > 0) {
                    [self createTableView];
                }
//                else {
//                    NSString *str = @"开启第一次训练打卡，记录我的华丽蜕变";
//                    UIFont *font = [UIFont systemFontOfSize:17];
//                    CGFloat width = [UILabel getWidthWithTitle:str font:font];
//                    CGFloat height = [UILabel getHeightByWidth:width title:str font:font];
//                    CGFloat margin = (kScreenWidth - width) * 0.5;
//                    CGFloat labelY = kScreenHeight * 0.5 - height * 0.5;
//                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin, labelY, width, height)];
//                    label.text = str;
//                    label.font = font;
//                    label.textColor = [UIColor colorWithRed:0.46 green:0.45 blue:0.45 alpha:1.00];
//                    [self.view addSubview:label];
//                    
//                }
                
//                [self.tableView reloadData];
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
    self.tabBarController.tabBar.hidden = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = @"我的动态";
    self.navigationItem.titleView = label;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    [self createTableView];
    // 当没有动态的时候显示提示
    NSString *str = @"开启第一次训练打卡，记录我的华丽蜕变";
    UIFont *font = [UIFont systemFontOfSize:17];
    CGFloat width = [UILabel getWidthWithTitle:str font:font];
    CGFloat height = [UILabel getHeightByWidth:width title:str font:font];
    CGFloat margin = (kScreenWidth - width) * 0.5;
    CGFloat labelY = kScreenHeight * 0.5 - height * 0.5;
    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, labelY, width, height)];
    tiplabel.text = str;
    tiplabel.font = font;
    tiplabel.textColor = [UIColor colorWithRed:0.46 green:0.45 blue:0.45 alpha:1.00];
    [self.view addSubview:tiplabel];
    
    [self requestData];
    
    // Do any additional setup after loading the view.
}

- (void)back {
    self.tabBarController.tabBar.hidden = NO;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//  左滑进入编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 表视图开始更新
    [tableView beginUpdates];
    
    MyNewsModel *model = self.newsItemArray[indexPath.row];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *urlString = [DELETEMYNEWSURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",[NSString GetURLEncodeWithUserToken]]];
    [session POST:urlString parameters:@{@"feed_id":model.ID, @"author_id":model.userId} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
    // 删除单元格
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    // 删除数组中与该单元格绑定的数据
    [self.newsItemArray removeObjectAtIndex:indexPath.row];
    
    if (!self.newsItemArray.count) {
        self.tableView.hidden = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = .0f;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:view];
//        [self.navigationController.view addSubview:view];
        [UIView animateWithDuration:.3 animations:^{
            view.alpha = .4f;
            view.alpha = .0f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }

    // 表视图结束更新
    [tableView endUpdates];
}

//  修改左滑出现的delete按钮的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
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
