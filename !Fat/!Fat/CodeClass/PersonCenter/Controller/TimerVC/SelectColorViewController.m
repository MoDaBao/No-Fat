//
//  SelectColorViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "SelectColorViewController.h"
#import "ColorItemCell.h"

@interface SelectColorViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SelectColorViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
        [_dataArray addObject:@{@"粉色":@"kPink"}];
        [_dataArray addObject:@{@"蓝色":@"kBlue"}];
        [_dataArray addObject:@{@"灰色":@"kGray"}];
        [_dataArray addObject:@{@"绿色":@"kGreen"}];
    }
    return _dataArray;
}

//  创建表视图
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ColorItemCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"颜色";
    // Do any additional setup after loading the view.
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createTableView];
}

- (void)back {
    self.passColor(self.color);
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----表视图代理-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentidier = @"reuse";
    ColorItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentidier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    NSDictionary *dic = self.dataArray[indexPath.row];
    [ChangeColorManager changColorWithImageView:cell.colorView color:dic.allValues.firstObject];
    cell.colorLabel.text = dic.allKeys.firstObject;
    cell.colorView.layer.cornerRadius = 5;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedView.image = nil;
    if ([dic.allValues.firstObject isEqualToString:self.color]) {
        cell.selectedView.image = [UIImage imageNamed:@"selected"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    self.color = dic.allValues.firstObject;
    [self.tableView reloadData];
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
