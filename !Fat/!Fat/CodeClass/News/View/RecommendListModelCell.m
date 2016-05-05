//
//  RecommendListModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendListModelCell.h"
#import "RecommendListModel.h"


@implementation RecommendListModelCell


- (void)setDataWithModel:(RecommendListModel *)model {

    //切割字符串 拼接图片
    NSArray *arr1 = [model.image componentsSeparatedByString:@"/"];
    NSString *imageName = [arr1 lastObject];

    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!320", imageName];
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:image]];
    
    //字体变颜色
    self.contentLabel.attributedText = [NSString changeColorWithContent:model.content];
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", model.commentCount];
    self.pariseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    
}


@end
