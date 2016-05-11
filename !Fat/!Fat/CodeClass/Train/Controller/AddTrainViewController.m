//
//  AddTrainViewController.m
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "AddTrainViewController.h"
#import "ProgramDailyListModel.h"
#import "ProgramModelCell.h"
#import "VideoModelCell.h"
#import "DetailProgram2ViewController.h"
#import "DetailProgramViewController.h"

@interface AddTrainViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segment;//  切换
@property (nonatomic, strong) UIScrollView *rootScrollView;//  根视图
@property (nonatomic, strong) UITableView *programTableView;//  训练计划
@property (nonatomic, strong) UITableView *singleTableView;//   单次训练
@property (nonatomic, strong) NSMutableArray *singleData;//  单次数据源
@property (nonatomic, strong) NSMutableArray *programData;//  训练计划数据源
@property (nonatomic, assign) NSInteger flag;//  0标记计划 1标记单次

@end

@implementation AddTrainViewController


#pragma mark ------lazyLoading-------

- (NSMutableArray *)programData {
    if (!_programData) {
        self.programData  = [NSMutableArray array];
    }
    return _programData;
}

- (NSMutableArray *)singleData {
    if (!_singleData) {
        self.singleData = [NSMutableArray array];
    }
    return _singleData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    _flag = 0;//  默认训练计划
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //  segment切换
    _segment = [[UISegmentedControl alloc] initWithItems:@[@"训练计划",  @"单次训练"]];
    _segment.frame = CGRectMake(0, 0, 200, 30);
    [_segment addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventValueChanged];
    _segment.tintColor = [UIColor grayColor];
    _segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segment;
    //  创建根视图
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    _rootScrollView.contentSize = CGSizeMake(2 * kScreenWidth, kScreenHeight - 64);
    _rootScrollView.contentOffset = CGPointZero;
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_rootScrollView];
    //  创建tableView
    [self createTableView];
    //  默认请求训练计划的数据源
    [self requestProgramData];
    
    // Do any additional setup after loading the view from its nib.
}

//  点击返回按钮的方法
- (void)backAction:(id)sender {
    // 返回显示tabbar
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//  切换
- (void)changeTableView:(id)sender {
    //  偏移
    [_rootScrollView setContentOffset:CGPointMake(_segment.selectedSegmentIndex * kScreenWidth, 0) animated:YES];
    
    if (0 == _segment.selectedSegmentIndex) {
        _flag = 0;
        if (self.programData.count) {
            return;
        }
        [self requestProgramData];
        
    } else {
        _flag = 1;
        if (self.singleData.count) {
            return;
        }
        [self requestSingleData];
    }
}

//  通过videoID获取Video
- (VideoModel *)getVideoByVideoID:(NSNumber *)videoID {
    for (VideoModel *video in _singleData) {
        if ([videoID isEqualToNumber:video.videoID]) {
            return video;
        }
    }
    return nil;
}


#pragma mark -------请求数据-------

//  请求训练计划的数据源
- (void)requestProgramData {
    // 网络请求
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:PROGRAMSLIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //  获取训练计划数据源
        for (NSDictionary *programDic in responseObject[@"programs"]) {
            
            NSMutableArray *dailyArray = [NSMutableArray array];
            //  获取训练详细数据源
            for (NSDictionary *dailyListDic in programDic[@"programDailyList"]) {
                ProgramDailyListModel *dailyList = [[ProgramDailyListModel alloc] init];
                [dailyList setValuesForKeysWithDictionary:dailyListDic];
                [dailyArray addObject:dailyList];
            }
            //            NSLog(@"ZZZZZZZZ%@",dailyArray);
            ProgramModel *program = [[ProgramModel alloc] init];
            [program setValuesForKeysWithDictionary:programDic];
            program.programDailyList = dailyArray;
            [self.programData addObject:program];
        }
        //        NSLog(@"XXXXXX%@",self.trainListArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_programTableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}

//  请求单次训练的数据
- (void)requestSingleData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:SINGLELIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);

        for (NSDictionary *video in responseObject[@"videos"]) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            [videoModel setValuesForKeysWithDictionary:video];
            [self.singleData addObject:videoModel];
        }
        NSLog(@"CCCCCC singleData = %@",self.singleData);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.singleTableView reloadData];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@",error);
    }];
}


#pragma mark --------创建训练列表--------

- (void)createTableView {
    //  创建计划表
    _programTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(_rootScrollView.bounds)) style:UITableViewStylePlain];
    //  设置代理
    _programTableView.delegate = self;
    _programTableView.dataSource = self;
    //  注册cell
    [_programTableView registerNib:[UINib nibWithNibName:@"ProgramModelCell" bundle:nil] forCellReuseIdentifier:@"pp"];
    _programTableView.showsVerticalScrollIndicator = NO;
//    _programTableView.backgroundColor = [UIColor greenColor];
    [_rootScrollView addSubview:_programTableView];
    
    //  创建单次表
    _singleTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(_rootScrollView.bounds)) style:UITableViewStylePlain];
    //  设置代理
    _singleTableView.delegate = self;
    _singleTableView.dataSource = self;
    //  注册cell
    [_singleTableView registerNib:[UINib nibWithNibName:@"VideoModelCell" bundle:nil] forCellReuseIdentifier:@"vv"];
    _singleTableView.showsVerticalScrollIndicator = NO;
//    _singleTableView.backgroundColor = [UIColor blueColor];
    [_rootScrollView addSubview:_singleTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------scrollview代理方法-------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _rootScrollView) {//  地址相同 确保触发的是根视图的滚动代理
        int x = scrollView.contentOffset.x / kScreenWidth;
        if (0 == x) {
            _segment.selectedSegmentIndex = 0;
            if (_programData.count) {
                return;
            }
            [self requestProgramData];
        } else {
            _segment.selectedSegmentIndex = 1;
            if (_singleData.count) {
                return;
            }
            [self requestSingleData];
        }
    }
}


#pragma mark ------tableView代理方法--------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _flag == 0 ? self.programData.count : self.singleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     BaseModel *model = _flag == 0 ? _programData[indexPath.row] : _singleData[indexPath.row];
     BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
     [cell setDataWithModel:model];
     return cell;
    */

    if (_flag == 0) {
        ProgramModel *model = self.programData[indexPath.row];
        ProgramModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pp" forIndexPath:indexPath];
        [cell setDataWithModel:model];
        return cell;
        
    } else {
        VideoModel *model = self.singleData[indexPath.row];
        VideoModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vv" forIndexPath:indexPath];
        [cell setDataWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _flag == 0 ? kScreenHeight / 2.5 : kScreenHeight / 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 判断用户是否登录
    NSString *userID = [[UserInfoManager shareInstance] getUserID];
    //登录状态 获取单例数据库对象
    UserTrainDB *db = [[UserTrainDB alloc] init];
    //获取数据表 没有就创建
    [db createDataTable];
    //查询数据
    NSArray *array = [db selectDataWithUserID:userID];
    
    if (!array.count) {
        DetailProgramViewController *detailVC = [[DetailProgramViewController alloc] init];
        detailVC.program = self.programData[indexPath.row];
        // push后隐藏tabbar
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        
        for (ProgramModel *model in array) {
            ProgramModel *program = self.programData[indexPath.row];
            if ([program.programID isEqualToString:model.programID]) {
                DetailProgram2ViewController *detailVC = [[DetailProgram2ViewController alloc] init];
                ProgramDailyListModel *dailyModel = program.programDailyList[0];
                VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
                detailVC.firstVideo = video;

                detailVC.program = program;
                [self.navigationController pushViewController:detailVC animated:YES];
            } else {
                DetailProgramViewController *detailVC = [[DetailProgramViewController alloc] init];
                detailVC.program = self.programData[indexPath.row];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
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
