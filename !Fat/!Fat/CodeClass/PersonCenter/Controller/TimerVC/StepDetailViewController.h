//
//  StepDetailViewController.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^StepBlock)(NSString *);
@interface StepDetailViewController : BaseViewController

@property (nonatomic, copy) StepBlock backBlock;
@property (nonatomic, copy) NSString *step;


@end
