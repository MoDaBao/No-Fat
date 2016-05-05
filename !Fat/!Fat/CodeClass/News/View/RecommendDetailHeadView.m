//
//  RecommendDetailHeadView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendDetailHeadView.h"
#import "RecommendListModel.h"

@implementation RecommendDetailHeadView

- (void)setDataWithModel:(RecommendListModel *)model {
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
//    self.nameLabel.text = @"zhongji";
   
    
    //切割字符串 拼接图片
    NSArray *arr = [model.image componentsSeparatedByString:@"/"];
    NSString *imageName = [arr lastObject];
    
    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!320", imageName];
    
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    
}



@end
