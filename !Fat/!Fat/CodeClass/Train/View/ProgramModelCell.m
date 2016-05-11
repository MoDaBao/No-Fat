//
//  ProgramModelCell.m
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "ProgramModelCell.h"
#import "UIImageView+WebCache.h"

@implementation ProgramModelCell

//  重写父类赋值方法
- (void)setDataWithModel:(ProgramModel *)model {
    [self.programImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.titleLabel.text = model.title;
    self.countLabel.text = [NSString stringWithFormat:@"%ld次 / 难度 ",model.programDailyList.count];
    self.difficultyImgView.image = model.difficultyImg;
    self.playCountLabel.text = [NSString stringWithFormat:@" / %@人训练过",model.playCount];
}

@end
