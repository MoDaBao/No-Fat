//
//  DetailProgramViewController.m
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "DetailProgramViewController.h"
#import "DetailHeaderView.h"
#import "ProgramDailyListModel.h"
#import "VideoModel.h"
#import "ProgramDailyListModelCell.h"
#import "NewsModel.h"
#import "DetailProgram2ViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "ProgramStatsModel.h"
#import "AppDelegate.h"

#define kHeaderViewHeight ([[UIScreen mainScreen] bounds].size.height - 20) / 2.5

@interface DetailProgramViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;//  控制内边距的滚动视图
@property (nonatomic, strong) UIScrollView *smallScrollView;//  承载tableView的滚动视图
@property (nonatomic, strong) UITableView *programTableView;
@property (nonatomic, strong) UITableView *newsTableView;
@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) NSMutableArray *allVideos;//  单次数据源
@property (nonatomic, strong) ProgramStatsModel *statsModel;

@property (nonatomic, strong) UIButton *commentBt;

@end

@implementation DetailProgramViewController

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
    [self requestDetailInfoDataWithProgramID:_program.programID];
    [self requestProgramStats];
    
    // 底层图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kHeaderViewHeight)];
    imgView.tag = 1000;
    [imgView sd_setImageWithURL:[NSURL URLWithString:_program.photo]];
    [self.view addSubview:imgView];
    
    // 创建控制内边距的滚动视图
    _bigScrollView = [self createScrollViewWithFrame:self.view.frame contentSize:CGSizeMake(kScreenWidth, kScreenHeight) contentOffset:CGPointMake(0, 0)];
    
    _bigScrollView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 49, 0);// 切内边距
    _bigScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bigScrollView];
    
    // 创建透明视图 从nib加载
    DetailHeaderView *clearView = [[[NSBundle mainBundle] loadNibNamed:@"DetailHeaderView" owner:nil options:nil] lastObject];
    clearView.frame = imgView.bounds;
    [clearView setDataWithProgramModel:_program];
    [_bigScrollView addSubview:clearView];

    // 创建bigScrollView的头视图
    UIView *headerView = [self createHeaderView];
    [_bigScrollView addSubview:headerView];
    
    // 创建承载tableView的滚动视图
    _smallScrollView = [self createScrollViewWithFrame:CGRectMake(0, kHeaderViewHeight + (kHeaderViewHeight / 2.5), kScreenWidth, _bigScrollView.frame.size.height - 49) contentSize:CGSizeMake(3 * kScreenWidth, _bigScrollView.frame.size.height - (kHeaderViewHeight / 2.5)) contentOffset:CGPointZero];
    _smallScrollView.backgroundColor = [UIColor redColor];
    [_bigScrollView addSubview:_smallScrollView];

    // 创建计划表
    _programTableView = [self createTableViewWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(_smallScrollView.bounds)) nibName:@"ProgramDailyListModelCell" reuseIdentifier:@"vc"];
    [_smallScrollView addSubview:_programTableView];
    /*
    // 创建动态表
    _newsTableView = [self createTableViewWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(_smallScrollView.bounds)) nibName:@"NewsModelCell" reuseIdentifier:NSStringFromClass([NewsModel class])];
    [_smallScrollView addSubview:_newsTableView];
    // 创建详情表
    _detailsView = [[UIWebView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, CGRectGetHeight(_smallScrollView.bounds))];
    [_smallScrollView addSubview:_detailsView];
    
    NSLog(@"yyyyyyyy%@",_statsModel.commentCount);
    */
    
    [self createButtonView];
    
    // Do any additional setup after loading the view from its nib.
}

//  点击返回按钮的方法
- (void)backAction:(id)sender {
    // 返回显示tabbar
//    self.hidesBottomBarWhenPushed = NO;
    [self.trainVC refreshView];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

//  点击更多按钮的方法
- (void)shareAction:(id)sender {
    [_bigScrollView setContentInset:UIEdgeInsetsMake(-kHeaderViewHeight + 44, 0, 0, 0)];
    // 设置navigationBar的透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
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


#pragma mark --------创建视图-------

//  封装创建滚动视图
- (UIScrollView *)createScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)contentSize contentOffset:(CGPoint)contentOffset {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.contentSize = contentSize;
    scrollView.contentOffset = contentOffset;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.contentInset  切内边距
//    scrollView.contentInset  = UIEdgeInsetsMake(50, 0, 0, 0);
//    scrollView.contentOffset 偏移量
    return scrollView;
}

//  创建滚动视图的头视图
- (UIView *)createHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, kScreenWidth, kHeaderViewHeight / 2.5)];
    
    // 创建教练简介视图
    CGFloat introH = CGRectGetHeight(headerView.bounds) / 2.5 * 1.5;
    UIView *introView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, introH)];
    introView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:introView];
    
    CGFloat space = introH / 5;//  间距
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(space, space / 2, 3 * space + space, 3 * space + space)];// 教练头像
    [icon sd_setImageWithURL:[NSURL URLWithString:_program.coachPhoto]];
    icon.layer.cornerRadius = CGRectGetWidth(icon.bounds) / 2.0;
    icon.layer.masksToBounds = YES;
    [introView addSubview:icon];
    
    //    CGFloat c = [_program getHeightOfCoachName];
    //    NSLog(@"&&&&&&&&&&%f",c);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.size.width + 2 * space, space, 3 * space, space)];// 教练姓名
    nameLabel.text = _program.coachName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [introView addSubview:nameLabel];
    
    UIButton *guanzhuBt = [UIButton buttonWithType:UIButtonTypeCustom];// 关注按钮
    guanzhuBt.frame = CGRectMake(icon.bounds.size.width + nameLabel.bounds.size.width + 2 * space, 0, space * 3, space * 3);
    [guanzhuBt setBackgroundImage:[[UIImage imageNamed:@"guanzhu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    guanzhuBt.block = ^{
        
    };
    [introView addSubview:guanzhuBt];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.bounds.size.width + 2 * space, 3 * space, kScreenWidth / 2, space)];// 教练介绍
    descLabel.text = _program.coachDesc;
    descLabel.textColor = [UIColor grayColor];
    descLabel.font = [UIFont systemFontOfSize:12];
    [introView addSubview:descLabel];
    
    // 创建菜单栏视图
    CGFloat menuH = CGRectGetHeight(headerView.bounds) / 2.5 * 1.0;
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, introH, kScreenWidth, menuH)];
    menuView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:menuView];
    
    CGFloat btWidth = (kScreenWidth - 2 * space) / 5;
    UIButton *programBt = [UIButton buttonWithType:UIButtonTypeCustom];// 计划按钮
    programBt.frame = CGRectMake(space, 0, btWidth, menuH);
    [programBt setTitle:@"计划" forState:UIControlStateNormal];
    programBt.block = ^{
        
    };
    [menuView addSubview:programBt];
    
    UIButton *newsBt = [UIButton buttonWithType:UIButtonTypeCustom];// 动态按钮
    newsBt.frame = CGRectMake(CGRectGetMaxX(programBt.frame) + CGRectGetWidth(programBt.bounds), 0, btWidth, menuH);
    [newsBt setTitle:@"动态" forState:UIControlStateNormal];
    newsBt.block = ^{
        
    };//newsBt.bounds.size.width * 4 + space
    [menuView addSubview:newsBt];
    
    UIButton *detailsBt = [UIButton buttonWithType:UIButtonTypeCustom];// 详情按钮
    detailsBt.frame = CGRectMake(CGRectGetMaxX(newsBt.frame) + CGRectGetWidth(programBt.frame), 0, btWidth, menuH);
    [detailsBt setTitle:@"详情" forState:UIControlStateNormal];
    detailsBt.block = ^{
        
    };
    [menuView addSubview:detailsBt];
    
    return headerView;
}

//  封装创建表
- (UITableView *)createTableViewWithFrame:(CGRect)frame nibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier  {
    // 创建
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
    // 设置代理
    tableView.delegate = self;
    tableView.dataSource = self;
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    tableView.backgroundColor = [UIColor blueColor];
    return tableView;
}

//  创建按钮
- (void)createButtonView {
    // 评论按钮
    _commentBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBt.frame = CGRectMake(0, kScreenHeight - 49, kScreenWidth / 2, 49);
    _commentBt.backgroundColor = [UIColor blackColor];
    _commentBt.block = ^ {
        //发表评论
    };
    [self.view addSubview:_commentBt];
    
    // 加入训练按钮
    UIButton *joinBt = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBt.frame = CGRectMake(kScreenWidth / 2, kScreenHeight - 49, kScreenWidth / 2, 49);
    [joinBt setTitle:@"加入训练计划" forState:UIControlStateNormal];
    [joinBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    joinBt.backgroundColor = [UIColor yellowColor];
    joinBt.block = ^ {
        //加入
        //移除前一个视图控制器
        NSMutableArray *allVC = [self.navigationController.viewControllers mutableCopy];
        [allVC removeObject:self];
        
        DetailProgram2ViewController *detailVC = [[DetailProgram2ViewController alloc] init];
        ProgramDailyListModel *dailyModel = _program.programDailyList[0];
        VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
        detailVC.firstVideo = video;
        detailVC.program = _program;
        
        [allVC addObject:detailVC];
        [self.navigationController setViewControllers:allVC animated:YES];
        
        // 登录状态 获取单例数据库对象
        UserTrainDB *db = [[UserTrainDB alloc] init];
        // 获取数据表 没有就创建
        [db createDataTable];
        // 插入数据
        [db insertDataWithModel:_program];
        
        // 加入训练时刷新
        [self.trainVC refreshView];
        
        [self.navigationController pushViewController:detailVC animated:YES];
    };
    [self.view addSubview:joinBt];
}


#pragma mark --------请求数据----------

//  请求训练的统计数据
- (void)requestProgramStats {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/getProgramStats?id=%@",_program.programID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 解析
        NSLog(@"zzzzzzzzz %@",responseObject);
        NSArray *stats = responseObject[@"stats"];
        ProgramStatsModel *statsModel = [[ProgramStatsModel alloc] init];
        [statsModel setValuesForKeysWithDictionary:stats.lastObject];
//        _statsModel = statsModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_commentBt setTitle:[NSString stringWithFormat:@"评论 %@",statsModel.commentCount] forState:UIControlStateNormal];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

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

            [self.programTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error is %@",error);
    }];
}

//  请求详情数据
- (void)requestDetailInfoDataWithProgramID:(NSString *)ProgramID {
    NSLog(@"--------%@",ProgramID);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.fit-time.cn/client/p%@.html",ProgramID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *html = responseObject;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            _detailsView.scalesPageToFit = NO;
            
            //修改后的效果
            //把原来的html通过importStyleWithHtmlString进行替换，修改html的布局
//            NSString *newString = [NSString importStyleWithHtmlString:self.readInfo.html];
//            //baseURL可以让界面加载的时候按照本地样式去加载
//            NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
            [self.detailsView loadHTMLString:html baseURL:nil];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------scrollview代理方法-------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _bigScrollView) {
        UIImageView *imageView = [self.view viewWithTag:1000];
        CGRect newFrame = imageView.frame;
        newFrame.origin.y = - (scrollView.contentOffset.y) / 10;
        imageView.frame = newFrame;
    }
}


#pragma mark --------tableView代理方法----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _program.programDailyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeaderViewHeight / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProgramDailyListModel *dailyModel = _program.programDailyList[indexPath.row];
    VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
//    [self.currentVideos addObject:video];
    ProgramDailyListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vc" forIndexPath:indexPath];
    [cell setDataWithVideoModel:video];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *AD = [UIApplication sharedApplication].delegate;
    AD.isAllowRotation = YES;
    
    PlayVideoViewController *playVC = [[PlayVideoViewController alloc] init];
    ProgramDailyListModel *dailyModel = _program.programDailyList[indexPath.row];
    VideoModel *video = [self getVideoByVideoID:dailyModel.videoId];
    playVC.video = video;
//    [self.navigationController pushViewController:playVC animated:YES];
    [self presentViewController:playVC animated:YES completion:nil];
}
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
