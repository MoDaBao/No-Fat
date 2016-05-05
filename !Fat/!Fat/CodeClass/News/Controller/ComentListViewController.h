//
//  ComentListViewController.h
//  !Fat
//
//  Created by hu胡洁佩 on 16/4/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendListModel.h"
#import "RecommendDetailModel.h"

@interface ComentListViewController : BaseViewController

@property (nonatomic, strong) NSNumber *feedId;

@property (nonatomic, strong) RecommendListModel *model;
@property (nonatomic, strong) RecommendDetailModel *detailModel;
@property (nonatomic, assign) CGFloat textHeight;

@end
