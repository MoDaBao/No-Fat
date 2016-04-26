//
//  MyNewsCell.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyNewsModel.h"

@interface MyNewsCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIImageView *newsImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;


+ (CGFloat)cellHeightForCell:(MyNewsModel *)model;

@end
