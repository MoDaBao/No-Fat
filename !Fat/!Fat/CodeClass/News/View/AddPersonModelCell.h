//
//  AddPersonModelCell.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BaseCollectionViewCell.h"

@interface AddPersonModelCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *guanzhu;
@end
