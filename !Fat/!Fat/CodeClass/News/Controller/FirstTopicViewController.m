//
//  FirstTopicViewController.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/24.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "FirstTopicViewController.h"
#import "FirstTopicHeaderView.h"
#import "TopicModel.h"
#import "AddTimeListModelCell.h"
#import "AddTimeDetailViewController.h"

@interface FirstTopicViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;


@property (nonatomic, copy) CGFloat (^CellHeightBlock)();


@end

@implementation FirstTopicViewController

//push过来隐藏tabbar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"话题详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddTimeListModelCell" bundle:nil] forCellReuseIdentifier:@"AddTimeListModelCell"];
    [self.view addSubview:self.tableView];
    
    [self requsetData];
    [self createHeaderView];
    // Do any additional setup after loading the view.
}

#pragma mark-----请求数据-------
- (void)requsetData {
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshTagFeed?tag_id=20"] dic:@{} finish:^(NSData *data) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic%@", dic);
        
        NSArray *arr = dic[@"feeds"];
        NSLog(@"%@", arr);
        for (NSDictionary *headDic in arr) {
            TopicModel *model = [[TopicModel alloc] init];
            [model setValuesForKeysWithDictionary:headDic];
            [self.listArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}


#pragma mark-----创建头视图------
- (void)createHeaderView {
    
    FirstTopicHeaderView *firstTopVC = [[[NSBundle mainBundle] loadNibNamed:@"FirstTopicHeaderView" owner:nil options:nil] lastObject];
    firstTopVC.frame = CGRectMake(0, 0, ScreenWidth,180);
    self.tableView.tableHeaderView = firstTopVC;
    
}

#pragma mark------tableViewDelegate-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicModel *model =self.listArr[indexPath.row];
    AddTimeListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTimeListModelCell" forIndexPath:indexPath];
    [cell setDataWithModel:model];
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            }else if ([model.avatar isEqualToString:@""]) {
                cell.headImageView.image = [UIImage imageNamed:@"111.jpeg"];
                
            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:image]];
                
                
            }
            
            cell.nameLabel.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];

    
    self.CellHeightBlock = ^{
        return cell.cellHeight;
    };
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.CellHeightBlock) {
        return self.CellHeightBlock();
    }else {
        return .0f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopicModel *model = self.listArr[indexPath.row];
    AddTimeDetailViewController *addTimeVC = [[AddTimeDetailViewController alloc] init];
    addTimeVC.feedId = model.ID;
    addTimeVC.model = model;
    [self.navigationController pushViewController:addTimeVC animated:YES];
    
}

- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
