//
//  RecommendListModelCell.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface RecommendListModelCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pariseCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentBT;
@property (weak, nonatomic) IBOutlet UIButton *praiseBT;
@end
