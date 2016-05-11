//
//  ProgramDailyListModelCell.h
//  NoFat
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "VideoModel.h"

@interface ProgramDailyListModelCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *difficultyImg;
@property (strong, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImg;


- (void)setDataWithVideoModel:(VideoModel *)model;

@end
