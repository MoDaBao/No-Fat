//
//  RecommendDetailModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/23.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendDetailModelCell.h"
#import "RecommendDetailModel.h"
#import "UserMessageViewController.h"

@implementation RecommendDetailModelCell
- (void)awakeFromNib{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    NSLog(@"11111");
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:tap];
    
}

- (void)tap:(UIGestureRecognizer *)tap {

  
    if (self.tapBlock) {
        self.tapBlock();
    }
   
    NSLog(@"ssssssss");
}

- (void)setDataWithModel:(RecommendDetailModel *)model {
    
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
//    self.userNameLabel.text = @"仲基";
    self.contentLabel.text = model.comment;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.createTime];
    if (model.praiseCount > 0) {
         self.praiseCountLabel.text = [NSString stringWithFormat:@"%@", model.praiseCount];
    }else {
        self.praiseCountLabel.hidden = YES;
    }
    
     self.textHeight = model.textHeight;
   
   
}



- (CGFloat)cellHeight
{
    //计算
    return CGRectGetMinY(self.contentLabel.frame) + self.textHeight + 20;
    
}

- (IBAction)dianzanBT:(id)sender {
}

@end
