//
//  TopicModel.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/24.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseModel.h"

@interface TopicModel : BaseModel

@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *programId;
@property (nonatomic, strong) NSNumber *programDailyId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *praiseCount;

@property (nonatomic, strong) NSNumber *ID;

@property (nonatomic, assign) CGFloat textHeight;

@end
