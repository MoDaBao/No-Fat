//
//  AttentionDetailViewController.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseViewController.h"
#import "AttentionListModel.h"
#import "RecommendDetailModel.h"

@interface AttentionDetailViewController : BaseViewController

@property (nonatomic, strong) NSNumber *feedId;
@property (nonatomic, assign) CGFloat textHeight;
@property (nonatomic, strong) AttentionListModel *model;
@property (nonatomic, strong) RecommendDetailModel *detailModel;

@end
