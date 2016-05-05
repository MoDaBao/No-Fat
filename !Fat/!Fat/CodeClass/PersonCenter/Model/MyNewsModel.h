//
//  MyNewsModel.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface MyNewsModel : BaseModel

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ID;

@end
