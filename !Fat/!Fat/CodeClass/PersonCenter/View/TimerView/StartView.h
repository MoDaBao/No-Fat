//
//  StartView.h
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartView : UIView
typedef void(^StartBlock)();

@property (nonatomic, copy) StartBlock start;

@end
