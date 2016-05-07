//
//  ManagerView.m
//  Timer
//
//  Created by 莫大宝 on 16/5/5.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ManagerView.h"

@implementation ManagerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)add:(id)sender {
    self.addClick();
}

- (IBAction)sub:(id)sender {
    self.subClick();
}

- (IBAction)copy:(id)sender {
    self.copyClick();
}

- (IBAction)down:(id)sender {
    self.downClick();
}

- (IBAction)up:(id)sender {
    self.upClick();
}

@end
