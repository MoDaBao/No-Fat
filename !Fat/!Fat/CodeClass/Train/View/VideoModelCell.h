//
//  VideoModelCell.h
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "VideoModel.h"

@interface VideoModelCell : BaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *difficultyImg;
@property (strong, nonatomic) IBOutlet UILabel *instrumentLabel;
@property (strong, nonatomic) IBOutlet UILabel *partLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAndplayCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoImg;

@end
