//
//  MenuItemCell.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MenuItemCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *detailMessageLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end
