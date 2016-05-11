//
//  DetailHeader2View.m
//  !Fat
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DetailHeader2View.h"

@implementation DetailHeader2View

- (void)setDataWithProgramModel:(ProgramModel *)programModel videoModel:(VideoModel *)videoModel {
    [_photoImg sd_setImageWithURL:[NSURL URLWithString:videoModel.photo]];
    _titleLabel.text = videoModel.title;
    _subTitleLabel.text = programModel.title;
    _prograssLabel.text = [NSString stringWithFormat:@"进度 %ld",programModel.programDailyList.count];
    _timeLabel.text = [NSString stringWithFormat:@"时间 %02d:%02d",videoModel.time.intValue / 60, videoModel.time.intValue % 60];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
