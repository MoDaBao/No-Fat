//
//  AddtimeDetailNoImageHeaderView.h
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseView.h"

@interface AddtimeDetailNoImageHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBT;
@property (weak, nonatomic) IBOutlet UIButton *progromBT;
@end
