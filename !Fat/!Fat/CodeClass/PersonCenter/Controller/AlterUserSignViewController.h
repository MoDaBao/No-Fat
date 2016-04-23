//
//  AlterUserSignViewController.h
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PassValueBlock)(NSString *);

@interface AlterUserSignViewController : BaseViewController

@property (nonatomic, copy) NSString *oldSign;

@end
