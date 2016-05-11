//
//  DetailProgramViewController.h
//  NoFat
//
//  Created by lanou on 16/4/20.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramModel.h"
#import "TrainTableViewController.h"
//#import "TrainTableViewController.h"

@interface DetailProgramViewController : BaseViewController

@property (nonatomic, strong) ProgramModel *program;
@property (nonatomic, strong) TrainTableViewController *trainVC;

@end
