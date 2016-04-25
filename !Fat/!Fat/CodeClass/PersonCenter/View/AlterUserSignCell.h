//
//  AlterUserSignCell.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"
typedef void(^PassValue)(NSString *, NSInteger);
@interface AlterUserSignCell : BaseTableViewCell<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *wordCount;
@property (nonatomic, assign) NSInteger count;
//@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) PassValue passValue;

@end
