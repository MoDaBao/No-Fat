//
//  DetailProgram2ViewController.m
//  !Fat
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DetailProgram2ViewController.h"
#import "DetailHeader2View.h"
#import "ProgramDailyListModelCell.h"
#import "ProgramDailyListModel.h"
#import "VideoModel.h"
#import "NewsModel.h"
#import "PlayVideoViewController.h"
#import "AppDelegate.h"

#define kHeaderHeight ([[UIScreen mainScreen] bounds].size.height - 20) / 2.5

@interface DetailProgram2ViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) UITableView *programTableView;
@property (nonatomic, strong) UITableView *newsTableView;
@property (nonatomic, strong) UITableView *detailsTableView;
@property (nonatomic, strong) DetailHeader2View *clearView;

@property (nonatomic, strong) NSMutableArray *allVideos;//  单次数据源

@end

static NSString *reuse = @"reuse";

@implementation DetailProgram2ViewController


- (NSMutableArray *)allVideos {
    if (!_allVideos) {
        self.allVideos = [NSMutableArray array];
    }
    return _allVideos;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置navigationBar的透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.0];
    // 设置按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // 请求数据
    [self requestAllVideosData];
    
    // 创建透明视图 从nib加载
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kHeaderHeight)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    _clearView = [[[NSBundle mainBundle] loadNibNamed:@"DetailHeader2View" owner:nil options:nil] lastObject];
    _clearView.frame = view.bounds;
    [_clearView setDataWithProgramModel:_program videoModel:_firstVideo];
    __weak DetailProgram2ViewController *detailVC = self;
    _clearView.playBt.block = ^{
        AppDelegate *AD = [UIApplication sharedApplication].delegate;
        AD.isAllowRotation = YES;
        PlayVideoViewController *playVC = [[PlayVideoViewController alloc] init];
        playVC.video = _firstVideo;
        [detailVC presentViewController:playVC animated:YES completion:nil];
    };
    [view addSubview:_clearView];
    
    // 创建按钮视图
    [self createButtonView];
    
    // 创建根视图
    CGFloat maxY = 20 + kHeaderHeight + 49;
    _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, maxY, kScreenWidth, kScreenHeight - maxY)];
    _rootScrollView.contentSize = CGSizeMake(3 * kScreenWidth, kScreenHeight - maxY);
    _rootScrollView.contentOffset = CGPointZero;
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_rootScrollView];

    // 创建列表
    [self createTableView];
    
    // Do any additional setup after loading the view from its nib.
}

//  点击返回按钮的方法
- (void)backAction:(id)sender {
//    NSArray *array = self.navigationController.viewControllers;
//    NSArray *arrayy = @[array[0], array[2]];
//    self.navigationController.viewControllers = arrayy;
    
    // 放弃训练时刷新
    [self.trainVC refreshView];
    // 返回显示tabbar
    self.hidesBottomBarWhenPushed = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  点击更多按钮的方法
- (void)shareAction:(id)sender {
    
}

//  通过videoID获取Video
- (VideoModel *)getVideoByVideoID:(NSNumber *)videoID {
    for (VideoModel *video in _allVideos) {
        if ([videoID isEqualToNumber:video.videoID]) {
            return video;
        }
    }
    return nil;
}


#pragma mark --------创建视图--------

//  创建按钮视图
- (void)createButtonView {
    
    CGFloat H = 49;
    CGFloat W = kScreenWidth / 5;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight + 20, kScreenWidth, H)];
    buttonView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:buttonView];
    
    UIButton *programBt = [UIButton buttonWithType:UIButtonTypeCustom];// 计划按钮
    programBt.frame = CGRectMake(0, 0, W, H);
    [programBt setTitle:@"计划" forState:UIControlStateNormal];
    programBt.block = ^{
        
    };
    [buttonView addSubview:programBt];
    
    UIButton *newsBt = [UIButton buttonWithType:UIButtonTypeCustom];// 动态按钮
    newsBt.frame = CGRectMake(CGRectGetMaxX(programBt.frame) + W, 0, W, H);
    [newsBt setTitle:@"动态" forState:UIControlStateNormal];
    newsBt.block = ^{
        
    };
    [buttonView addSubview:newsBt];
    
    UIButton *detailsBt = [UIButton buttonWithType:UIButtonTypeCustom];// 详情按钮
    detailsBt.frame = CGRectMake(CGRectGetMaxX(newsBt.frame) + W, 0, W, H);
    [detailsBt setTitle:@"详情" forState:UIControlStateNormal];
    detailsBt.block = ^{
        
    };
    [buttonView addSubview:detailsBt];
}

- (void)createTableView {
    
    //  创建计划表
    _programTableView = [[UITableView alloc] initWithFrame:_rootScrollView.bounds style:UITableViewStylePlain];
    //  设置代理
    _programTableView.delegate = self;
    _programTableView.dataSource = self;
    //  注册cell
    [_programTableView registerNib:[UINib nibWithNibName:@"ProgramDailyListModelCell" bundle:nil] forCellReuseIdentifier:reuse];
    _programTableView.backgroundColor = [UIColor greenColor];
    [_rootScrollView addSubview:_programTableView];
    
//    //  创建动态表
//    _newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 450, kScreenWidth, CGRectGetHeight(_rootScrollView.bounds) - 450) style:UITableViewStylePlain];
//    //  设置代理
//    _newsTableView.delegate = self;
//    _newsTableView.dataSource = self;
//    //  注册cell
//    [_newsTableView registerNib:[UINib nibWithNibName:@"NewsModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([NewsModel class])];
//    _newsTableView.showsVerticalScrollIndicator = NO;
//    _newsTableView.backgroundColor = [UIColor blueColor];
//    [_rootScrollView addSubview:_newsTableView];
}


#pragma mark --------请求数据----------

//  请求单次训练的数据
- (void)requestAllVideosData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:SINGLELIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        for (NSDictionary *video in responseObject[@"videos"]) {
            VideoModel *videoModel = [[VideoModel alloc] init];
            [videoModel setValuesForKeysWithDictionary:video];
            [self.allVideos addObject:videoModel];
        }
        NSLog(@"XXXXXXXX singleData = %@",self.allVideos);
        
        dispatch_async(dispatch_get_main_queue(), ^{
//                        [self createTableView];
            [self.programTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
    }];
}

//  请求训练的统计数据
- (void)requestProgramStats {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/getProgramStats?id=%@",_program.programID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 解析
        NSLog(@"zzzzzzzzz %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------scrollview代理方法-------

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}


#pragma mark --------tableView代理方法----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _program.programDailyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kHeaderHeight - 44) / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProgramDailyListModel *dailyModel = _program.programDailyList[indexPath.row];
    VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
    ProgramDailyListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    [cell setDataWithVideoModel:video];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgramDailyListModel *dailyModel = _program.programDailyList[indexPath.row];
    VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
    [_clearView setDataWithProgramModel:_program videoModel:video];
    __weak DetailProgram2ViewController *detailVC = self;
    
    _clearView.playBt.block = ^{
        AppDelegate *AD = [UIApplication sharedApplication].delegate;
        AD.isAllowRotation = YES;
        PlayVideoViewController *playVC = [[PlayVideoViewController alloc] init];
        playVC.video = video;
        [detailVC presentViewController:playVC animated:YES completion:nil];
    };
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
