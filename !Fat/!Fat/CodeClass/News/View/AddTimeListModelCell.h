//
//  AddTimeListModelCell.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AddTimeListModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pariseCountLabrl;
@property (weak, nonatomic) IBOutlet UIButton *commentBT;
@property (weak, nonatomic) IBOutlet UIButton *shareBT;
@property (weak, nonatomic) IBOutlet UIButton *praiseBT;

@property (weak, nonatomic) IBOutlet UIButton *attentionBT;//关注按钮

@property (nonatomic ,assign) CGFloat cellHeight;//计算高度的属性
@property (nonatomic, assign) CGFloat textHeight;

@end
