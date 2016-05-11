//
//  PlayerClearView.h
//  !Fat
//
//  Created by lanou on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerClearView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishTiemLabel;
@property (strong, nonatomic) IBOutlet UISlider *prograssSlider;
@property (strong, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIButton *playAndPauseBt;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
