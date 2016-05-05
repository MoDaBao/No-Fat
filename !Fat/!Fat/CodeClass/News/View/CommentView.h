//
//  CommentView.h
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/26.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "BaseView.h"

@protocol CommentViewDelegate <NSObject>

- (void)clickButton:(UIButton *)sender;

@end
@interface CommentView : BaseView


@property (weak, nonatomic) IBOutlet UIButton *commentBT;
@property (weak, nonatomic) IBOutlet UIButton *praiseBT;
@property (weak, nonatomic) IBOutlet UIButton *shareBT;

@property (nonatomic, assign)id<CommentViewDelegate>delegate;

+ (instancetype)commentView;
@end
