//
//  AlterUserNameCell.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^PassValueBlock)(NSString *);
@interface AlterUserNameCell : BaseTableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) PassValueBlock passValue;

@end
