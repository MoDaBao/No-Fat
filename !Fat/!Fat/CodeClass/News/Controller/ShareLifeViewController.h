//
//  ShareLifeViewController.h
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareLifeViewController : BaseViewController

@property (nonatomic, assign) BOOL isTrain;// 是否是训练打卡
@property (nonatomic, copy) NSString *trainName;// 训练名称
@property (nonatomic, copy) NSString *trainDesc;// 训练描述
@property (nonatomic, assign) NSNumber *priv;//是否加密

@end
