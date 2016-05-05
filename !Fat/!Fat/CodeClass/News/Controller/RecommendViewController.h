//
//  RecommendViewController.h
//  
//
//  Created by hu胡洁佩 on 16/4/20.
//
//

#import "BaseViewController.h"
#import "RecommendListModel.h"
#import "RecommendDetailModel.h"

@interface RecommendViewController : BaseViewController

@property (nonatomic, strong) NSNumber *feedId;

@property (nonatomic, strong) RecommendListModel *model;
@property (nonatomic, strong) RecommendDetailModel *detailModel;
@property (nonatomic, assign) CGFloat textHeight;

@end
