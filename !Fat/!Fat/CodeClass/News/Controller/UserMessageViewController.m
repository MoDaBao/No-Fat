//
//  UserMessageViewController.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/4/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "UserMessageViewController.h"
#import "UserMessageHeaderView.h"
#import "UserMessageModel.h"
#import "UserDynamicModelCell.h"
#import "UserInfoModel.h"
#import "RecommendDetailModel.h"
#import "DynamicPhotoListViewController.h"

@interface UserMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UserMessageHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *userArr;
@property (nonatomic, strong) NSMutableArray *statArr;

@property (nonatomic, strong) NSMutableArray *NewsListArr;

@end

@implementation UserMessageViewController

- (NSMutableArray *)statArr {
    if (!_statArr) {
        _statArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _statArr;
}

- (NSMutableArray *)userArr {
    if (!_userArr) {
        _userArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _userArr;
}

- (NSMutableArray *)NewsListArr {
    if (!_NewsListArr) {
        _NewsListArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _NewsListArr;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //导航栏的的返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
     [self requestData];
//    [self createTableView];
    [self createHeaderView];
//     NSLog(@"%@", self.NewsListArr);
    
//    [_tableView registerNib:[UINib nibWithNibName:@"UserDynamicModelCell" bundle:nil] forCellReuseIdentifier:@"UserDynamicModelCell"];
    // Do any additional setup after loading the view from its nib.
}


- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserDynamicModelCell" bundle:nil] forCellReuseIdentifier:@"UserDynamicModelCell"];
    self.tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

- (void)createHeaderView {
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserMessageHeaderView" owner:nil options:nil]lastObject];
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/loadUserProfile?user_id=%@", _userId ] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", dic);
        
        NSDictionary *user = [dic objectForKey:@"user"];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:user];
    
        NSDictionary *stat = [dic objectForKey:@"stat"];
        UserMessageModel *mesageModel = [[UserMessageModel alloc] init];
        [mesageModel setValuesForKeysWithDictionary:stat];
    
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        self.headerView.totalDaysLabel.text = [NSString stringWithFormat:@"%@天",mesageModel.totalDays];
        self.headerView.totalCountsLabel.text = [NSString stringWithFormat:@"%@次",mesageModel.totalCounts];
        self.headerView.totalCalLabel.text = [NSString stringWithFormat:@"%@大卡",mesageModel.totalCal];
            self.headerView.exceedLabel.text = [NSString stringWithFormat:@"训练次数超过%@的人", mesageModel.exceed];
            
//            _headerView.totalCountsLabel.text = [NSString stringWithFormat:@"%@次",mesageModel.totalCounts];
//            _headerView.totalCalLabel.text = [NSString stringWithFormat:@"%@大卡", mesageModel.totalCal];
            
            //切割字符串 拼接图片
            NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
            NSString *imageName = [arr lastObject];
            
            NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@small2", imageName];
            
            [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:image]];
            
            self.headerView.nameLabel.text = model.username;
            self.headerView.addressLabel.text = model.birth;
            
            self.headerView.contentLabel.text = model.sign;
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        
        
    }];
    
    //粉丝个数的数据
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/getUserStatByIds?id=%@", _userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        
        NSArray *arr = dic[@"userStats"];
//        NSLog(@"%@", arr);
        
        NSDictionary *dataDic = arr[0];
//        NSLog(@"%@", dataDic);
        
        UserInfoModel *infoModel = [[UserInfoModel alloc] init];
        [infoModel setValuesForKeysWithDictionary:dataDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str =[_headerView.fansCount titleForState:UIControlStateNormal];
            if ([str isEqualToString:@"0"]) {
            [_headerView.fansCount setTitle:@"0粉丝" forState:UIControlStateNormal];
            }else{
           [_headerView.fansCount setTitle:[NSString stringWithFormat:@"%@粉丝",infoModel.fansCount] forState:UIControlStateNormal];
            }
            if ([[_headerView.fansCount titleForState:UIControlStateNormal] isEqualToString:@"0"]) {
                 [_headerView.fansCount setTitle:@"0关注" forState:UIControlStateNormal];
            }else {
            [_headerView.AttentionCount setTitle:[NSString stringWithFormat:@"%@关注",infoModel.followCount] forState:UIControlStateNormal];
            }
        });
    } error:^(NSError *error) {
        
        
    }];
    
}

//  请求动态的cell的数据
- (void)requestData {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshUserFeed?user_id=%@", _userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject%@", responseObject);
        
        NSArray *arr = responseObject[@"feeds"];
        for (NSDictionary *dic in arr) {
            RecommendListModel *model = [[RecommendListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.NewsListArr addObject:model];
        }
//        NSLog(@"%@", self.NewsListArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [self.tableView reloadData];
            [self createTableView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.NewsListArr.count == 0) {
        return 0;
    }else {
    return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    RecommendListModel *model = self.NewsListArr[indexPath.row];
 
  UserDynamicModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDynamicModelCell" forIndexPath:indexPath];
//    [cell setDataWithModel:model];
    if (self.NewsListArr.count > 4) {
        for (int i = 0; i < 4; i ++) {
            RecommendListModel *model = self.NewsListArr[i];
            NSArray *arr1 = [model.image componentsSeparatedByString:@"/"];
            NSString *imageName = [arr1 lastObject];
            NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small", imageName];
            CGFloat width = ScreenWidth / 5 - 10;
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * (i + 1) + 5, 10, width - 5, cell.frame.size.height - 20)];
            //        headerImageView.backgroundColor = [UIColor redColor];
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:image]];
            
            //        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:image]];
            [cell addSubview:headerImageView];
        }

    }else {
        for (int i = 0; i < self.NewsListArr.count; i ++) {
            RecommendListModel *model = self.NewsListArr[i];
            NSArray *arr1 = [model.image componentsSeparatedByString:@"/"];
            NSString *imageName = [arr1 lastObject];
            NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small", imageName];
            CGFloat width = ScreenWidth / 5 - 10;
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * (i + 1) + 5, 10, width - 5, cell.frame.size.height - 20)];
            //        headerImageView.backgroundColor = [UIColor redColor];
            [headerImageView sd_setImageWithURL:[NSURL URLWithString:image]];
            
            //        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:image]];
            [cell addSubview:headerImageView];
        }

    }
    
//    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    RecommendDetailModel *model = self.NewsListArr[indexPath.row];
    DynamicPhotoListViewController *dynamic = [[DynamicPhotoListViewController alloc] init];
    dynamic.userId = _userId;
    [self.navigationController pushViewController:dynamic animated:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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
