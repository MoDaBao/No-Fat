//
//  ProgramDailyListModelCell.m
//  NoFat
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "ProgramDailyListModelCell.h"
#import "UIImageView+WebCache.h"

@implementation ProgramDailyListModelCell

- (void)setDataWithVideoModel:(VideoModel *)model {
    
    self.titleLabel.text = model.title;
    self.difficultyImg.image = model.difficultyImg;
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",model.time.intValue / 60, model.time.intValue % 60];
    if (model.instrument) {
        self.instrumentLabel.text = @"无器械";
    } else {
        self.instrumentLabel.text = model.instrument;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
