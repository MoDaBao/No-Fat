//
//  DetailProgram2ViewController.h
//  !Fat
//
//  Created by lanou on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "BaseViewController.h"
#import "ProgramModel.h"
#import "VideoModel.h"
#import "TrainTableViewController.h"


@interface DetailProgram2ViewController : BaseViewController

@property (nonatomic, strong) ProgramModel *program;
@property (nonatomic, strong) VideoModel *firstVideo;
@property (nonatomic, strong) TrainTableViewController *trainVC;

@end
