//
//  RegistViewController.h
//  No!Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^MyBlock)(NSString *mobile);
@interface RegistViewController : BaseViewController

@property (nonatomic, copy) MyBlock mobilBlock;

@end
