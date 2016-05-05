//
//  AddPersonModel.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseModel.h"

@interface AddPersonModel : BaseModel

@property (nonatomic, copy) NSString *avatar;//图片
@property (nonatomic, copy) NSString *username;//名字
@property (nonatomic, strong) NSNumber *userid;// 用户id
@property (nonatomic, strong) NSNumber *type;

@end
