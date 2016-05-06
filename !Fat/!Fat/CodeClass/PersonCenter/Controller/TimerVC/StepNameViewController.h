//
//  StepNameViewController.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PassValueBlock)(NSString *);
@interface StepNameViewController : BaseViewController
@property (nonatomic, copy) NSString *stepName;
@property (nonatomic, copy) PassValueBlock passValue;
@end
