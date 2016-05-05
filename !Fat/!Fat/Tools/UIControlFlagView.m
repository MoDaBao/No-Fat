//
//  UIControlFlagView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "UIControlFlagView.h"

@interface UIControlFlagView()

@property (nonatomic, strong) UIImageView *noStateImgV;
@property (nonatomic, strong) UIImageView *yesStateImgV;
@property (nonatomic, strong) UIImageView *defaultStateImgV;

@end

@implementation UIControlFlagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
     
        _noStateImg = [UIImage imageNamed:@"pinglun"];
        _yesStateImg = [UIImage imageNamed:@"back"];
    }
    return self;
}


- (void)setNoStateImg:(UIImage *)noStateImg
{
    if (!self.noStateImgV)
    {
        self.noStateImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.noStateImgV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.noStateImgV];
        self.flag = FlagModelNO;//default style
    }
    self.noStateImgV.image = noStateImg;
    _noStateImg = noStateImg;
}

- (void)setYesStateImg:(UIImage *)yesStateImg
{
    if (!self.yesStateImgV)
    {
        self.yesStateImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.yesStateImgV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.yesStateImgV];
        self.yesStateImgV.alpha = 0.0;
    }
    self.yesStateImgV.image = yesStateImg;
    _yesStateImg = yesStateImg;
}

- (void)setDefaultStateImg:(UIImage *)defaultStateImg
{
    if (!self.defaultStateImgV)
    {
        self.defaultStateImgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.defaultStateImgV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.defaultStateImgV];
    }
    self.defaultStateImgV.image = defaultStateImg;
    _defaultStateImg = defaultStateImg;
}

- (void)setFlag:(UIControlFlagMode)flag withAnimation:(BOOL)animation
{
    
    
    if (animation)
    {
        //no-->yes
        if (_flag == FlagModelNO && flag == FlagModelYES)
        {
            self.yesStateImgV.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.noStateImgV.alpha = 0.0;
                self.yesStateImgV.alpha = 1.0;
                self.yesStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                self.noStateImgV.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                
            }
                             completion:^(BOOL finished)
             {
                 self.yesStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                 self.noStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             }];
            
        }
        //yes-->no
        else if(_flag == FlagModelYES && flag == FlagModelNO)
        {
            self.noStateImgV.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.noStateImgV.alpha = 1.0;
                self.yesStateImgV.alpha = 0.0;
                self.yesStateImgV.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
                self.noStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                
            }
                             completion:^(BOOL finished)
             {
                 self.yesStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                 self.noStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
             }];
        }
        
    }
    else
    {
        //no-->yes
        if (_flag == FlagModelNO && flag == FlagModelYES)
        {
            self.noStateImgV.alpha = 0.0;
            self.yesStateImgV.alpha = 1.0;
            self.yesStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.noStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }
        //yes-->no
        else if(_flag == FlagModelYES && flag == FlagModelNO)
        {
            self.noStateImgV.alpha = 1.0;
            self.yesStateImgV.alpha = 0.0;
            self.yesStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.noStateImgV.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }
    }
    
    _flag = flag;
}

@end
