//
//  AlterUserSignCell.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface AlterUserSignCell : BaseTableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *wordCount;
@property (nonatomic, assign) NSInteger count;

@end
