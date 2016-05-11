//
//  DetailHeaderView.h
//  NoFat
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"

@interface DetailHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *difficultyImg;
@property (strong, nonatomic) IBOutlet UILabel *statsLabel;

- (void)setDataWithProgramModel:(ProgramModel *)programModel;

@end
