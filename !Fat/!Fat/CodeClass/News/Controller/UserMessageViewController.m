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

@interface UserMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UserMessageHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *userArr;
@property (nonatomic, strong) NSMutableArray *statArr;

@end

@implementation UserMessageViewController

- (NSMutableArray *)statArr {
    if (_statArr) {
        _statArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _statArr;
}

- (NSMutableArray *)userArr {
    if (_userArr) {
        _userArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _userArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self requestData];
    [self createTableView];
    [self createHeaderView];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData {
   
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"UserDynamicModelCell" bundle:nil] forCellReuseIdentifier:@"reuse"];
    
    [self.view addSubview:_tableView];
}

- (void)createHeaderView {
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserMessageHeaderView" owner:nil options:nil]lastObject];
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/loadUserProfile?user_id=%@", _userId ] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
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
    
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/getUserStatByIds?id=%@", _userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        
        NSArray *arr = dic[@"userStats"];
        NSLog(@"%@", arr);
        
        NSDictionary *dataDic = arr[0];
        NSLog(@"%@", dataDic);
        
        UserInfoModel *infoModel = [[UserInfoModel alloc] init];
        [infoModel setValuesForKeysWithDictionary:dataDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [_headerView.fansCount setTitle:[NSString stringWithFormat:@"%@粉丝",infoModel.fansCount] forState:UIControlStateNormal];
            [_headerView.AttentionCount setTitle:[NSString stringWithFormat:@"%@关注",infoModel.followCount] forState:UIControlStateNormal];
            
        });
    } error:^(NSError *error) {
        
        
    }];
    
    
    self.tableView.tableHeaderView = _headerView;
    

    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserDynamicModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    cell.headerImage.image = [UIImage imageNamed:@""];
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
