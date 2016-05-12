//
//  AddTimeNoImageModelCell.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/21.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AddTimeNoImageModelCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pariseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *commentBT;
@property (weak, nonatomic) IBOutlet UIButton *praiseBT;
@property (weak, nonatomic) IBOutlet UIButton *shareBT;
@property (weak, nonatomic) IBOutlet UIButton *attentionBT;//关注按钮
@property (weak, nonatomic) IBOutlet UIButton *trainingTextBT;

@property (nonatomic ,assign) CGFloat cellHeight;//计算高度的属性
@property (nonatomic, assign) CGFloat textHeight;//属性 接受model的字符串的高度的属性

@end
