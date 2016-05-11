//
//  VideoModel.h
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel

@property (nonatomic, strong) NSNumber *videoID;
@property (nonatomic, strong) UIImage *difficultyImg;
@property (nonatomic, strong) NSNumber *difficulty;//  难度
@property (nonatomic, copy) NSString *title;//  标题
@property (nonatomic, copy) NSString *url;//  视频地址
@property (nonatomic, copy) NSString *part;//  部位
@property (nonatomic, strong) NSNumber *playCount;//  练过人数
@property (nonatomic, copy) NSString *photo;//  图片
@property (nonatomic, strong) NSNumber *time;//  时间
@property (nonatomic, copy) NSString *instrument;//  器械

//@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *youkuUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *flagFee;
@property (nonatomic, copy) NSString *kcal;
@property (nonatomic, copy) NSString *qiniuUrl;
@property (nonatomic, copy) NSString *single;
@property (nonatomic, copy) NSString *source;

@end
