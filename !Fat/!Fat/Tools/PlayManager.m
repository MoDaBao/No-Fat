//
//  PlayManager.m
//  !Fat
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "PlayManager.h"

@implementation PlayManager

//  单例 APP运行只可能播放一个音频
+ (instancetype)shareInstance {
    static PlayManager *playManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playManager = [[PlayManager alloc] init];
    });
    return playManager;
}

//  重写初始化方法
- (instancetype)init {
    if (self = [super init]) {
        _playerState = playerStatePlay;// 默认播放状态
    }
    return self;
}

//  重写下面的getter方法
//- (AVPlayerItem *)getPlayerItem{
//    
//    NSAssert(self.url != nil, @"必须先传入视频url！！！");
//    
////    if ([self.videoUrl rangeOfString:@"http"].location != NSNotFound) {
////        AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[self.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
////        return playerItem;
////    }else{
////        AVAsset *movieAsset  = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:self.videoUrl] options:nil];
////        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
////        return playerItem;
////    }
//    // 创建播放单元
//    AVPlayerItem *item = nil;
//    if ([_url hasPrefix:@"http"]) {
//        // 通过网络路径创建
//        item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_url]];
//    } else {
//        // 通过本地路径创建
//        item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:_url]];
//    }
//    return item;
//}
//
//- (AVPlayer *)player{
//    if (!_player) {
//        AVPlayerItem *playerItem = [self getPlayerItem];
//        self.playerItem = playerItem;
//        _player = [AVPlayer playerWithPlayerItem:playerItem];
//        
////        [self addProgressObserver];
////        [self addObserverToPlayerItem:playerItem];
//    }
//    return _player;
//}
//
//- (AVPlayerLayer *)playerLayer {
//    if (!_playerLayer) {
//        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
//        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
//    }
//    return _playerLayer;
//}

//  重写currentTime的getter方法
- (CGFloat)currentTime {
    if (_player.currentItem.timebase == 0) {
        return 0;
    }
    return _player.currentTime.value / _player.currentTime.timescale;
}

//  重写totalTime的getter方法
- (CGFloat)totalTime {
    if (_player.currentItem.duration.timescale == 0) {
        return 0;
    }
    return _player.currentItem.duration.value / _player.currentItem.duration.timescale;
}

//  重写url来创建播放器
- (void)setUrl:(NSString *)url {
    // 创建播放单元
    AVPlayerItem *item = nil;
    if ([url hasPrefix:@"http"]) {
        // 通过网络路径创建
        item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    } else {
        // 通过本地路径创建
        item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:url]];
    }
    // 创建播放器
    _player = [[AVPlayer alloc] initWithPlayerItem:item];
}

//  播放
- (void)play {
    [_player play];
    _playerState = playerStatePlay;
}

//  暂停
- (void)pause {
    [_player pause];
    _playerState = playerStatePause;
}

//  停止
- (void)stop {
//    [_player seekToTime:0];
    [_player pause];
}

- (void)seekToNewTime:(CGFloat)newTime {
    
}

- (void)playerDidFinish {
    
}

@end
