//
//  PlayVideoViewController.m
//  !Fat
//
//  Created by lanou on 16/4/28.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayManager.h"
#import "AppDelegate.h"
#import "PlayerClearView.h"
#import "NSTimer+Addition.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayVideoViewController ()

@property (nonatomic, strong) PlayerClearView *clearView;//  透明视图
//@property (nonatomic, strong) UISlider *progressSlider;//  进度条
//@property (nonatomic, strong) UILabel *finishTimeLabel;//  完成播放时长
//@property (nonatomic, strong) UILabel *remainTimeLabel;//  剩余时长

@end

@implementation PlayVideoViewController

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ %@ %@",_video.url,_video.title, _video.youkuUrl);
    
    
//    self.navigationController.navigationBarHidden = YES;
    
    // 设置按钮
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
//    self.navigationItem.leftBarButtonItem = item;
    
    // 创建播放器管理对象
    PlayManager *playManager = [PlayManager shareInstance];
    // 创建播放器器
    [playManager setUrl:_video.url];
    // 创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:playManager.player];
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer addSublayer:playerLayer];
    // 默认播放
    [playManager play];
    
    // 创建一个计时器
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playing:) userInfo:nil repeats:YES];
    
    // 创建透明视图
    [self createClearView];
    
    // Do any additional setup after loading the view from its nib.
}

//- (void)viewWillAppear:(BOOL)animated {
//    
////    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
////    appDelegate.isAllowRotation = NO;
//}

//  计时器每秒触发的方法 播放时
- (void)playing:(id)sender {
    
    PlayManager *playManager = [PlayManager shareInstance];
    
    // 设置进度条
    self.clearView.prograssSlider.minimumValue = 0;
    self.clearView.prograssSlider.maximumValue = playManager.totalTime;
    self.clearView.prograssSlider.value = playManager.currentTime;
    
    // 修改时间
    _clearView.finishTiemLabel.text = [NSString stringWithFormat:@"%02lld : %02lld",(int64_t)playManager.currentTime / 60, (int64_t)playManager.currentTime % 60];
    _clearView.finishTiemLabel.text = [NSString stringWithFormat:@"%02lld:%02lld",(int64_t)(playManager.totalTime - playManager.currentTime) / 60, (int64_t)(playManager.totalTime - playManager.currentTime) % 60];
}

//  创建透明视图
- (void)createClearView {
    
    NSArray *clearViews = [[NSBundle mainBundle] loadNibNamed:@"PlayerClearView" owner:nil options:nil];
    PlayerClearView *clearView = clearViews[0];
    clearView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _clearView = clearView;
    [self.view addSubview:_clearView];
    
    /*
    _clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:_clearView];
    
    // 视频标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    titleLabel.text = _video.title;
    [_clearView addSubview:titleLabel];
    
    // 播放暂停按钮
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(5, 300 - 35, 30, 30);
    [bt setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    __weak UIButton *bb = bt;
    bt.block = ^{
        // 播放 暂停
        PlayManager *playManager = [PlayManager shareInstance];
        if (playManager.playerState == playerStatePlay) {
            // 是播放就暂停
            [playManager pause];
            [bb setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        } else {
            // 是暂停就播放
            [playManager play];
            [bb setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }
    };
    [_clearView addSubview:bt];
    
    // 进度条
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(40 + 35, 300 - 40 , kScreenWidth - 80 - 40, 40)];
    self.progressSlider.value = 0;
    [self.progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [_clearView addSubview:_progressSlider];
    
    // 完成播放的时间显示
    _finishTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 300 - 35, 30, 30)];
    _finishTimeLabel.text = @"00:00";
    _finishTimeLabel.textColor = [UIColor whiteColor];
    [_clearView addSubview:_finishTimeLabel];
    
    // 剩余时间显示
    _remainTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 45, 300 - 35, 30, 30)];
    _remainTimeLabel.text = @"00:00";
    _remainTimeLabel.textColor = [UIColor whiteColor];
    [_clearView addSubview:_remainTimeLabel];
     */
    [_clearView.playAndPauseBt addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
    [_clearView.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearView.prograssSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    _clearView.titleLabel.text = _video.title;
    // 完成播放的时间显示
    _clearView.finishTiemLabel.text = @"00:00";
    _clearView.finishTiemLabel.textColor = [UIColor whiteColor];
    
    // 剩余时间显示
    _clearView.remainTimeLabel.text = @"00:00";
    _clearView.remainTimeLabel.textColor = [UIColor whiteColor];
    
}

- (void)back:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.isAllowRotation = NO;
//    [self.navigationController popViewControllerAnimated:YES];
//    self.navigationController.navigationBarHidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playAndPause:(id)sender {
    // 播放 暂停
    PlayManager *playManager = [PlayManager shareInstance];
    if (playManager.playerState == playerStatePlay) {
        // 是播放就暂停
        [playManager pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        // 是暂停就播放
        [playManager play];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }

}

//  拖动进度条触发的方法
- (void)valueChanged:(id)sender {
    PlayManager *playManager = [PlayManager shareInstance];
    [playManager pause];
    CMTime newTime = playManager.player.currentTime;
    newTime.value = self.clearView.prograssSlider.value * newTime.timescale;
    [playManager.player seekToTime:newTime completionHandler:^(BOOL finished) {
        [playManager play];
    }];
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
