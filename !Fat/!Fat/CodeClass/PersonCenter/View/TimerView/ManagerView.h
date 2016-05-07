//
//  ManagerView.h
//  Timer
//
//  Created by 莫大宝 on 16/5/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagerView : UIView
typedef void(^ButtonClick)();

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, copy) ButtonClick addClick;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (nonatomic, copy) ButtonClick subClick;
@property (weak, nonatomic) IBOutlet UIButton *copyitemBtn;
@property (nonatomic, copy) ButtonClick copyClick;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (nonatomic, copy) ButtonClick downClick;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (nonatomic, copy) ButtonClick upClick;
@end
