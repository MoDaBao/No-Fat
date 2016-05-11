//
//  DetailHeaderView.m
//  NoFat
//
//  Created by lanou on 16/4/21.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "DetailHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation DetailHeaderView

- (void)setDataWithProgramModel:(ProgramModel *)programModel {
    _titleLabel.text = programModel.title;
    _difficultyImg.image = programModel.difficultyImg;
    if (programModel.instrument) {
        self.instrumentLabel.text = @"/无器械";
    } else {
        self.instrumentLabel.text = programModel.instrument;
    }
    _statsLabel.text = [NSString stringWithFormat:@"%ld次  %@人训练过",programModel.programDailyList.count, programModel.playCount];
    //   feeImg
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
