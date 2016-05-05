//
//  UserModel.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/21.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSString *ID;//用户ID
@property (nonatomic, copy) NSString *username;//用户名
@property (nonatomic, strong) NSNumber *gender;//年龄
@property (nonatomic, copy) NSString *avatar;//头像
@property (nonatomic, copy) NSString *mobile;//手机号码
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *sign;//个性签名
@property (nonatomic, copy) NSString *birth;//生日
@property (nonatomic, copy) NSString *adcode;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, copy) NSString *trainGoal;//阶段
@property (nonatomic, copy) NSString *trainBase;//学习等级
@property (nonatomic, copy) NSString *trainFrequency;//训练强度


//@property (nonatomic, strong) NSNumber *ID;	//:	124162



/*trainGoal	:	减脂
trainBase	:	初学者
trainFrequency	:	每周1-2次*/


@end
