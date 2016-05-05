//
//  RecommendDetailModel.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendDetailModel : BaseModel

@property (nonatomic, copy) NSString *comment;//评论的内容
@property (nonatomic, strong) NSNumber *createTime;//时间
@property (nonatomic, strong) NSNumber *userId;//用户的id
@property (nonatomic, strong) NSNumber *hot;//是否是热门
@property (nonatomic, strong) NSNumber *praiseCount;//点赞次数

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, assign) CGFloat textHeight;//字符串高度
@end
