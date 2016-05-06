//
//  SelectColorViewController.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PassColor)(NSString *);
@interface SelectColorViewController : BaseViewController

@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) PassColor passColor;

@end
