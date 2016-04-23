//
//  AlterUserNameViewController.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PassValueBlock)(NSString *);

@interface AlterUserNameViewController : BaseViewController

@property (nonatomic, copy) PassValueBlock passValue;
@property (nonatomic, copy) NSString *oldUserName;

@end
