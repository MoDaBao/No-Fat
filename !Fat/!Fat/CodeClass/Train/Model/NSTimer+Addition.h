//
//  NSTimer+Addition.h
//  AVPlayer
//
//  Created by 诸超杰 on 16/4/18.
//  Copyright © 2016年 诸超杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)
// 暂停
- (void)pauseTimer;
// 继续
- (void)resumeTimer;
// 在多少秒以后继续
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
