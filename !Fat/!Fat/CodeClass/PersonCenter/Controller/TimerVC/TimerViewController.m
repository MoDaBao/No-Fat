//
//  TimerViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/4/18.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerListItemModel.h"
#import "TimerListItemDB.h"
#import "TimerItemManagerViewController.h"
#import "TimerDetailItemDB.h"

@interface TimerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;// 表视图
@property (nonatomic, strong) NSMutableArray *itemListArray;

@end

@implementation TimerViewController


- (NSMutableArray *)itemListArray {
    if (!_itemListArray) {
        self.itemListArray = [NSMutableArray array];
        TimerListItemDB *db = [[TimerListItemDB alloc] init];
        [db createTable];
        NSArray *array = [db selectAllData];
        for (TimerListItemModel *model in array) {
            [_itemListArray addObject:model];
        }
    }
    return _itemListArray;
}

//  创建表视图
- (void)createTable {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"TimerListItemModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TimerListItemModel class])];
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationItem.title = @"计时器";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 20);
    [button setTitle:@"更多" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    titleLabel.text = @"我的计时器";
    titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = titleLabel;
    
    
    [self createTable];
    // Do any additional setup after loading the view.
}

- (void)back {
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    [self.itemListArray removeAllObjects];
    TimerListItemDB *db = [[TimerListItemDB alloc] init];
    NSArray *array = [db selectAllData];
    for (TimerListItemModel *model in array) {
        [_itemListArray addObject:model];
    }
    [self.tableView reloadData];
}

//  更多按钮
- (void)more {
    NSLog(@"2333");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:@"新建" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TimerItemManagerViewController *managerVC = [[TimerItemManagerViewController alloc] init];
        managerVC.isNew = 1;
        [self.navigationController pushViewController:managerVC animated:YES];
    }];
    UIAlertAction *managerAction = [UIAlertAction actionWithTitle:@"管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *backupAction = [UIAlertAction actionWithTitle:@"备份" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *restoreAction = [UIAlertAction actionWithTitle:@"恢复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:newAction];
    [alertController addAction:managerAction];
    [alertController addAction:backupAction];
    [alertController addAction:restoreAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


#pragma mark -----表视图代理方法-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = self.itemListArray[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
}

//  左滑进入编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确认删除?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 表视图开始更新
        [tableView beginUpdates];
        // 删除单元格
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // 删除数据库数据
        TimerListItemModel *model = self.itemListArray[indexPath.row];
        TimerListItemDB *db = [[TimerListItemDB alloc] init];
        [db deleteWithTitle:model.title];
        TimerDetailItemDB *detailItemDB = [[TimerDetailItemDB alloc] init];
        [detailItemDB deleteWithTitle:model.title];
        // 删除数组中与该单元格绑定的数据,此步骤应该在最后一步做
        [self.itemListArray removeObjectAtIndex:indexPath.row];
        // 表视图结束更新
        [tableView endUpdates];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmAction];
//    uipicker
    [self presentViewController:alert animated:YES completion:nil];
    
}

//  修改左滑出现的delete按钮的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TimerListItemModel *model = self.itemListArray[indexPath.row];
    TimerItemManagerViewController *managerVC = [[TimerItemManagerViewController alloc] init];
    managerVC.isNew = 0;
    managerVC.headTitle = model.title;
    [self.navigationController pushViewController:managerVC animated:YES];
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
