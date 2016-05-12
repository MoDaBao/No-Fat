//
//  AddtimeDetailNoImageHeaderView.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AddtimeDetailNoImageHeaderView.h"
#import "AddTimeListModel.h"

@implementation AddtimeDetailNoImageHeaderView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDataWithModel:(AddTimeListModel *)model {
    
    //    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    //    self.nameLabel.text = @"zhongji";
    self.contentLabel.text = model.content;
    
}

@end
