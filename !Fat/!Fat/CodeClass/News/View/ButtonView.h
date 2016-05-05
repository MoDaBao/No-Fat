//
//  ButtonView.h
//  No! Fat
//
//  Created by hu胡洁佩 on 16/4/19.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonViewDelegete<NSObject>
- (void)didClickButton:(UIButton *)sender;
@end

@interface ButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *tuijian;
@property (weak, nonatomic) IBOutlet UIButton *guanzhu;
@property (weak, nonatomic) IBOutlet UIButton *zuixin;
@property (nonatomic,weak) id<ButtonViewDelegete> delegete;
+ (instancetype)buttonView;
@end
