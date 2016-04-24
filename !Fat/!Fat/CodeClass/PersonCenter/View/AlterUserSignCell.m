//
//  AlterUserSignCell.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlterUserSignCell.h"

@implementation AlterUserSignCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.count = 70;
        self.backgroundColor = [UIColor clearColor];
        CGFloat cellHeight = 200;
        CGFloat labelHeight = 35;
        CGFloat margin = 10;
        self.wordCount = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight - labelHeight, kScreenWidth - margin, labelHeight)];
        self.wordCount.textAlignment = NSTextAlignmentRight;
        self.wordCount.text = [NSString stringWithFormat:@"%ld",_count];
        self.wordCount.font = [UIFont systemFontOfSize:13];
        self.wordCount.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.wordCount];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, cellHeight - labelHeight)];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textView];
        
        
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger singleWidth = [UILabel getWidthWithTitle:@"卧" font:textView.font];
    NSInteger textWidht = [UILabel getWidthWithTitle:textView.text font:textView.font];
    NSInteger count = textWidht / singleWidth;
    self.wordCount.text = [NSString stringWithFormat:@"%ld",_count - count];
//    NSLog(@"%ld",count);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 把textView的文本内容传回视图控制器
    self.passValue(self.textView.text);
    if ([text isEqualToString:@"\n"]) {
        // 改变个人简介
        
    }
    return YES;
}




@end
