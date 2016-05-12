//
//  DynamicPhotoListViewCell.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DynamicPhotoListViewCell.h"


@implementation DynamicPhotoListViewCell

- (void)setDataWithModel:(RecommendListModel *)model {
    
    NSArray *arr1 = [model.image componentsSeparatedByString:@"/"];
        NSString *imageName = [arr1 lastObject];
    
        NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small", imageName];
    
        [self.dynameicImage sd_setImageWithURL:[NSURL URLWithString:image]];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
