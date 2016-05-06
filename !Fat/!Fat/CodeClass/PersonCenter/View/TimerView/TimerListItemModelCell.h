//
//  TimerListItemModelCell.h
//  Timer
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TimerListItemModel.h"


@interface TimerListItemModelCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) UIColor *iconBGColor;

@property (nonatomic, strong) TimerListItemModel *timerListItemModel;




@end
