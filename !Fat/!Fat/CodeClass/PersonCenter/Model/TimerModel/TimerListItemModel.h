//
//  TimerListItemModel.h
//  Timer
//
//  Created by 莫大宝 on 16/4/18.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseModel.h"

@interface TimerListItemModel : BaseModel

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *iconBGColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;



@end
