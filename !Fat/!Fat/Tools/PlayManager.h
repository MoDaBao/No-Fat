//
//  PlayManager.h
//  !Fat
//
//  Created by lanou on 16/4/30.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//  播放状态
typedef NS_ENUM(NSInteger, PlayerState) {
    playerStatePlay,
    playerStatePause
};

@interface PlayManager : NSObject

//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
//@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) PlayerState playerState;
@property (nonatomic, assign, readonly) CGFloat currentTime;
@property (nonatomic, assign, readonly) CGFloat totalTime;
@property (nonatomic, copy) NSString *url;

+ (instancetype)shareInstance;

- (void)play;

- (void)pause;

- (void)stop;

//- (void)setVidioPath:(NSString *)path;

- (void)seekToNewTime:(CGFloat)newTime;

- (void)playerDidFinish;

@end
