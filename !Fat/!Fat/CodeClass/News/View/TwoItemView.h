//
//  TwoItemView.h
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainItemView.h"
#import "LifeItemView.h"

@interface TwoItemView : UIView

//@property (nonatomic, strong) UIButton *trainBtn;
//@property (nonatomic, strong) UIButton *lifeBtn;
//@property (nonatomic, strong) UILabel *trainLabel;
//@property (nonatomic, strong) UILabel *trainDescLabel;
//@property (nonatomic, strong) UILabel *lifeLabel;
//@property (nonatomic, strong) UILabel *lifeDescLabel;

@property (nonatomic, strong) TrainItemView *trainView;
@property (nonatomic, strong) LifeItemView *lifeView;

@end
