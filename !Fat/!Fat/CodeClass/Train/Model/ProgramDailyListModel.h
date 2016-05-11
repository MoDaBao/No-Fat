//
//  ProgramDailyListModel.h
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseModel.h"

@interface ProgramDailyListModel : BaseModel

@property (nonatomic, copy) NSString *breakAfter;
@property (nonatomic, copy) NSString *dailyID;
@property (nonatomic, copy) NSString *programId;
@property (nonatomic, strong) NSNumber *videoId;

@end
