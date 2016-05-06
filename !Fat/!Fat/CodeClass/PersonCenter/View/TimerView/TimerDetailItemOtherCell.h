//
//  TimerDetailItemOtherCell.h
//  Timer
//
//  Created by 莫大宝 on 16/5/3.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TimerDetailItemModel.h"
@interface TimerDetailItemOtherCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (void)setDataWithModel:(TimerDetailItemModel *)model indexPath:(NSIndexPath *)indexPath;

@end
