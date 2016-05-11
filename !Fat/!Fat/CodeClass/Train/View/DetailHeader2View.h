//
//  DetailHeader2View.h
//  !Fat
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"
#import "VideoModel.h"

@interface DetailHeader2View : UIView

@property (strong, nonatomic) IBOutlet UIImageView *photoImg;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *prograssLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *downBt;
@property (strong, nonatomic) IBOutlet UIButton *playBt;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

- (void)setDataWithProgramModel:(ProgramModel *)programModel videoModel:(VideoModel *)videoModel;

@end
