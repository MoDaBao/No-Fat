//
//  PlaceHolderTextView.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame isTrain:(BOOL)isTrain trainName:(NSString *)trainName trainDesc:(NSString *)trainDesc {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat publicViewHeight = frame.size.height / 7;
        CGFloat marginTop = 10;
        // textView的placeholder
        self.placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + marginTop, frame.size.width, 20)];
        self.placeHolder.text = @"分享点什么...";
        self.placeHolder.font = [UIFont systemFontOfSize:13];
        self.placeHolder.textColor = [UIColor lightGrayColor];
        [self addSubview:self.placeHolder];
        
        CGFloat newPubViewHeight = publicViewHeight;
        if (isTrain) {// 如果训练打卡则留出位置显示传过来的训练描述
            newPubViewHeight = publicViewHeight * 2;
        }
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, marginTop, frame.size.width, frame.size.height - marginTop - newPubViewHeight)];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        [self addSubview:self.textView];
        
        CGFloat margin = 20;
        UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(margin, self.textView.frame.size.height - 1 + marginTop, frame.size.width - margin * 2, 1)];
        lineOne.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineOne];
        
        UIView *publicView = [[UIView alloc] initWithFrame:CGRectMake(0, self.textView.frame.origin.y + self.textView.frame.size.height, kScreenWidth, publicViewHeight)];
        [self addSubview:publicView];
        
        
        
        CGFloat imageWidth = 20;
        CGFloat imageHeight = imageWidth;
        CGFloat imageX = 10;
        CGFloat imageY = publicViewHeight * 0.5 - imageHeight * 0.5;
        self.publicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        self.publicImageView.image = [UIImage imageNamed:@"eyeNormal"];
        [publicView addSubview:self.publicImageView];
        
        
        self.publicLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.publicImageView.frame.origin.x + imageWidth, 0, 100, publicView.frame.size.height)];
        self.publicLabel.text = @" 公开";
        self.publicLabel.font = [UIFont systemFontOfSize:13];
        CGFloat labelWidth = [UILabel getWidthWithTitle:self.publicLabel.text font:self.publicLabel.font];
        CGRect newFrame = self.publicLabel.frame;
        newFrame.size.width = labelWidth;
        self.publicLabel.frame = newFrame;
        //        self.publicLabel.textColor = [UIColor lightGrayColor];
        [publicView addSubview:self.publicLabel];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.publicLabel.frame.origin.x + self.publicLabel.frame.size.width, 0, 200, publicView.frame.size.height)];
        self.descLabel.text = @" (该动态所有人可见)";
        self.descLabel.font = [UIFont systemFontOfSize:11];
        self.descLabel.textColor = [UIColor lightGrayColor];
        [publicView addSubview:self.descLabel];
        
        self.publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.publicBtn.frame = CGRectMake(0, 0, publicView.frame.size.width, publicView.frame.size.height);
        [self.publicBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        //        [self.publicBtn setImage:[UIImage imageNamed:@"eyeNormal"] forState:UIControlStateNormal];
        [publicView addSubview:self.publicBtn];
        
        self.isPublic = 1;
        
        if (isTrain) {// 如果是训练打卡要显示训练描述
            UIView *doneView = [[UIView alloc] initWithFrame:CGRectMake(0, publicView.frame.origin.y + publicViewHeight, kScreenWidth, publicViewHeight)];
//            doneView.backgroundColor = [UIColor orangeColor];
            UIFont *doneFont = [UIFont systemFontOfSize:13];
            CGFloat doneWidth = [UILabel getWidthWithTitle:@"完成" font:doneFont];
            CGFloat doneMargin = 12;
            UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(doneMargin, 0, doneWidth, publicViewHeight)];
            doneLabel.font = doneFont;
            doneLabel.text = @"完成";
            [doneView addSubview:doneLabel];
            
            self.trainLabel = [[UILabel alloc] initWithFrame:CGRectMake(doneLabel.frame.origin.x + doneWidth + imageX, 0, 200, publicViewHeight)];
            self.trainLabel.font = doneFont;
            self.trainLabel.textColor = [UIColor colorWithRed:0.00 green:0.73 blue:0.61 alpha:1.00];
            self.trainLabel.text = [NSString stringWithFormat:@"%@·%@",trainName, trainDesc];
            [doneView addSubview:self.trainLabel];
            
            [self addSubview:doneView];
            
        
            UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(margin, publicView.frame.origin.y + publicView.frame.size.height - 1, frame.size.width - margin * 2, 1)];
            lineTwo.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:lineTwo];
        }

    }
    
    return self;
}

- (void)change {
    self.isPublic = !self.isPublic;
    if (_isPublic) {
        self.publicImageView.image = [UIImage imageNamed:@"eyeNormal"];
        self.publicLabel.text = @" 公开";
        self.descLabel.text = @" (该动态所有人可见)";
    } else {
        self.publicImageView.image = [UIImage imageNamed:@"eyeHighlight"];
        self.publicLabel.text = @" 私密";
        self.descLabel.text = @" (该动态仅自己可见)";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeHolder.hidden = YES;
    } else {
        self.placeHolder.hidden = NO;
    }
    self.content = textView.text;
}


@end
