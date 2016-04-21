//
//  PersonCenterHeaderView.h
//  No!Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserNameAndGenderView.h"

@interface PersonCenterHeaderView : UIView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *fansCountLabel;
@property (nonatomic, strong) UILabel *focusCountLabel;
@property (nonatomic, strong) UIImageView *genderImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
//@property (nonatomic, strong) UserNameAndGenderView *userNAGView;


@end
