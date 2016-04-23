//
//  MenuItemCell.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/21.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MenuItemCell.h"
#define kCellHeight self.frame.size.height

@implementation MenuItemCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier
        ]) {
        CGFloat marginLX = 15;
        CGFloat marginRX = 5;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginLX, 0, kScreenWidth, kCellHeight)];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview: self.messageLabel];
        
        CGFloat imageWidth = 15;
        CGFloat imageHeight = 15;
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - imageWidth - marginRX, kCellHeight * 0.5 - imageHeight * 0.5, imageWidth, imageHeight)];
        self.rightImageView.image = [UIImage imageNamed:@"right"];
        [self.contentView addSubview:self.rightImageView];
        
        self.detailMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, kCellHeight)];
        self.detailMessageLabel.textAlignment = NSTextAlignmentRight;
        self.detailMessageLabel.textColor = [UIColor lightGrayColor];
        self.detailMessageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.detailMessageLabel];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        CGFloat marginLX = 15;
//        CGFloat marginRX = 5;
//        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginLX, 0, kScreenWidth, kCellHeight)];
//        self.messageLabel.textAlignment = NSTextAlignmentLeft;
//        [self addSubview: self.messageLabel];
//        
//        CGFloat imageWidth = 15;
//        CGFloat imageHeight = 15;
//        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - imageWidth - marginRX, kCellHeight * 0.5 - imageHeight * 0.5, imageWidth, imageHeight)];
//        self.rightImageView.image = [UIImage imageNamed:@"right"];
//        [self addSubview:self.rightImageView];
//        
//        self.detailMessageLabeel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, kCellHeight)];
//        self.detailMessageLabeel.textAlignment = NSTextAlignmentRight;
//        self.detailMessageLabeel.textColor = [UIColor lightGrayColor];
//        [self addSubview:self.detailMessageLabeel];
//        
//        
//    }
//    return self;
//}

@end
