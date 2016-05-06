//
//  ColorItemCell.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ColorItemCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;

@end
