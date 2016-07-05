//
//  MOTimerProgressView.h
//  test
//
//  Created by 莫大宝 on 16/5/9.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOTimerProgressView : UIView
@property (nonatomic, strong) NSTimer *timer;

- (instancetype)initWithFrame:(CGRect)frame loopTime:(NSTimeInterval)loopTimer bgColor:(UIColor *)bgColor;

@end
