//
//  ProgramStatsModel.h
//  NoFat
//
//  Created by lanou on 16/4/22.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseModel.h"

@interface ProgramStatsModel : BaseModel

@property (nonatomic, copy) NSString *programId;
@property (nonatomic, copy) NSString *commentCount;//   评论数
@property (nonatomic, copy) NSString *praiseCount;//  点赞数
@property (nonatomic, copy) NSString *playCount;//  练过人数

@end
