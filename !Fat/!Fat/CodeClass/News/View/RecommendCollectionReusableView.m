//
//  RecommendCollectionReusableView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendCollectionReusableView.h"

@implementation RecommendCollectionReusableView

+ (instancetype)buttonView {
    return [[[NSBundle mainBundle] loadNibNamed:@"RecommendCollectionReusableView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
      [self.firstTopic addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)click:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTopicButton:)]) {
        [self.delegate didTopicButton:self.firstTopic];
    }
    
}

@end
