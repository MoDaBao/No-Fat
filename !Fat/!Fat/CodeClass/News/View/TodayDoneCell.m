//
//  TodayDoneCell.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "TodayDoneCell.h"
#import "TodayDoneModel.h"

@implementation TodayDoneCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat labelHeight = 30;
        CGFloat labelWidth = frame.size.width;
        CGFloat labelX = 0;
        CGFloat labelY = frame.size.height * 0.5 - labelHeight * 0.5;
        self.trainItem = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        self.trainItem.font = [UIFont systemFontOfSize:14];
        self.trainItem.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.trainItem];
    }
    return self;
}

- (void)setDataWithModel:(TodayDoneModel *)model {
    self.trainItem.text = model.desc;
}

@end
