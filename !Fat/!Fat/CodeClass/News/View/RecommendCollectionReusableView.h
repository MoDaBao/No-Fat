//
//  RecommendCollectionReusableView.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewViewController.h"

@protocol RecommendCollectionReusableViewDelegete<NSObject>
- (void)didTopicButton:(UIButton *)sender;
@end

@interface RecommendCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *firstTopic;
@property (nonatomic, assign) id<RecommendCollectionReusableViewDelegete>delegate;
+ (instancetype)buttonView;


@end
