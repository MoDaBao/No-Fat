//
//  VideoModelCell.m
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "VideoModelCell.h"
#import "UIImageView+WebCache.h"

@implementation VideoModelCell

- (void)setDataWithModel:(VideoModel *)model {

    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.difficultyImg.image = model.difficultyImg;
    self.titleLabel.text = model.title;
    self.partLabel.text = model.part;
    self.timeAndplayCountLabel.text = [NSString stringWithFormat:@"%02d:%02d        %@人练过",model.time.intValue / 60, model.time.intValue % 60, model.playCount.stringValue];
    if (model.instrument) {
        self.instrumentLabel.text = @"  /  无器械";
    } else {
        self.instrumentLabel.text = model.instrument;
    }
}

- (IBAction)downLoad:(id)sender {
    
}

@end
