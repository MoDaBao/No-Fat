//
//  MyCollectionReusableView.m
//  UIConllectionView
//
//  Created by lanou on 16/1/26.
//  Copyright (c) 2016年 lanou. All rights reserved.
//

#import "MyCollectionReusableView.h"

@implementation MyCollectionReusableView

//增广视图
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.headerLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        self.headerLabel.font = [UIFont boldSystemFontOfSize:17];
        
        [self addSubview:self.headerLabel];
        
    }
    return self;
}

@end
