//
//  UserModel.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//
//  暂时没用到的类

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSString *avatar;// 头像
@property (nonatomic, strong) NSNumber *gender;// 性别
@property (nonatomic, copy) NSString *username;// 用户名
@property (nonatomic, copy) NSString *mobile;// 手机号码
@property (nonatomic, strong) NSNumber *ID;// 用户id
@property (nonatomic, strong) NSNumber *height;// 用户身高
@property (nonatomic, strong) NSNumber *weight;// 用户体重



@end
