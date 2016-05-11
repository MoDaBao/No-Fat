//
//  ProgramModel.h
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseModel.h"

@interface ProgramModel : BaseModel

@property (nonatomic, strong) NSMutableArray *programDailyList;
//@property (nonatomic, strong) baseRecommendFactor;
@property (nonatomic, strong) UIImage *difficultyImg;
@property (nonatomic, copy) NSString *instrument;//  器械

//  教练信息
@property (nonatomic, copy) NSString *coachDesc;
@property (nonatomic, copy) NSString *coachId;
@property (nonatomic, copy) NSString *coachPhoto;
@property (nonatomic, copy) NSString *coachName;

@property (nonatomic, copy) NSString *programID;//  节目ID
@property (nonatomic, copy) NSString *title;//  节目标题
//@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *subtitle;//  副标题
@property (nonatomic, copy) NSString *photo;//  封面图片
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, copy) NSString *flagFee;//  标记付费
@property (nonatomic, copy) NSString *flagFeeVip;//  标记VIP
@property (nonatomic, copy) NSString *playCount;//  练过人数

//@property (nonatomic, copy) NSString *descExerciser;
//@property (nonatomic, copy) NSString *descGoal;
//@property (nonatomic, copy) NSString *descSimple;
//@property (nonatomic, copy) NSString *descTime;
//@property (nonatomic, copy) NSString *recommend;
//@property (nonatomic, copy) NSString *shareObject;
//@property (nonatomic, copy) NSString *status;


//  获取coachName字符串的宽度
- (CGFloat)getHeightOfCoachName;

@end
