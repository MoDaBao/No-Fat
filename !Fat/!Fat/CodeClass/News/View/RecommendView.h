//
//  RecommendView.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseView.h"
#import "NewViewController.h"
#import "RecommendCollectionReusableView.h"


@interface RecommendView : BaseView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NewViewController *parent;
@property (nonatomic, strong) RecommendCollectionReusableView *view;
@property (nonatomic, strong) AddNewsView *addview;

@end
