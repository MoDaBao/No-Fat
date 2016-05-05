//
//  UserMessageHeaderView.h
//  !Fat
//
//  Created by hu胡洁佩 on 16/4/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseView.h"

@interface UserMessageHeaderView : BaseView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIButton *fansCount;
@property (weak, nonatomic) IBOutlet UIButton *AttentionCount;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *AttentionBT;
@property (weak, nonatomic) IBOutlet UILabel *exceedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCalLabel;
@end
