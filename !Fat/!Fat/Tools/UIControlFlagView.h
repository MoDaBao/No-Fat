//
//  UIControlFlagView.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, UIControlFlagMode) {
    FlagModelNO,
    FlagModelYES,
    FlagModelDefalt
};

@interface UIControlFlagView : UIControl

@property (nonatomic, strong) UIImage*noStateImg;
@property (nonatomic, strong) UIImage*yesStateImg;
@property (nonatomic, strong) UIImage*defaultStateImg;

@property (nonatomic, assign) UIControlFlagMode flag;

- (void)setFlag:(UIControlFlagMode)flag withAnimation:(BOOL)animation;

@end
