//
//  RecommendListModel.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendListModel : BaseModel

@property (nonatomic, strong) NSNumber *userId;//用户ID
@property (nonatomic, copy) NSString *image;//图片
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, strong) NSNumber *commentCount;//评论次数
@property (nonatomic, strong) NSNumber *praiseCount;//点赞次数
@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, strong) NSNumber *ID;

@end
