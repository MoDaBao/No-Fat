//
//  ProgramModelCell.h
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ProgramModel.h"

@interface ProgramModelCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *programImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIImageView *difficultyImgView;
@property (strong, nonatomic) IBOutlet UILabel *playCountLabel;

@end
