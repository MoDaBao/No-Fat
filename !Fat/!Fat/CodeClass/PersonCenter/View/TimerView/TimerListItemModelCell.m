//
//  TimerListItemModelCell.m
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerListItemModelCell.h"
#import "TimerListItemModel.h"

@implementation TimerListItemModelCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(TimerListItemModel *)model {
    if (_timerListItemModel != model) {
        _timerListItemModel = nil;
        _timerListItemModel = model;
    }
    
    if ([model.iconBGColor isEqualToString:@"kPink"]) {
        self.iconImageView.backgroundColor = kPink;
    } else if ([model.iconBGColor isEqualToString:@"kGary"]) {
        self.iconImageView.backgroundColor = kGray;
    } else if ([model.iconBGColor isEqualToString:@"kBlue"]) {
        self.iconImageView.backgroundColor = kBlue;
    }
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
