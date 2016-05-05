//
//  RecommendDetailModelCell.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecommendDetailModel.h"

@interface RecommendDetailModelCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *dainzanBT;

@property (nonatomic ,assign) CGFloat cellHeight;//计算高度的属性
@property (nonatomic, assign) CGFloat textHeight;//属性 接受model的字符串的高度的属性

@property (nonatomic, copy) void (^tapBlock)();

@end
