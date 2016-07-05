//
//  TimeringViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/7.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimeringViewController.h"
#import "MOTimerProgressView.h"


@interface TimeringViewController ()

@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) MOTimerProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval time;

@end

@implementation TimeringViewController


#pragma mark -----lazyloading-----
- (NSMutableArray *)stepArray {
    if (!_stepArray) {
        self.stepArray = [NSMutableArray array];
        NSArray *array = [self.detailModel.step componentsSeparatedByString:@"/"];
        for (NSString *step in array) {
            NSArray *stepArray = [step componentsSeparatedByString:@"&"];
            [self.stepArray addObject:@{stepArray[1]:stepArray[2]}];// 将标题和对应的时间添加进数组中
        }
        [self.stepArray addObject:@" "];
    }
    return _stepArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新计时器";
    [ChangeColorManager changColorWithImageView:self.view color:self.detailModel.titlecolor];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    NSString *timestr = [[[self.stepArray firstObject] allValues] firstObject];
    NSArray *timearr = [timestr componentsSeparatedByString:@":"];
    self.time = [timearr[0] intValue] * 60 + [timearr[1] intValue];
    
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(jishi) userInfo:nil repeats:YES];
    
    self.progressView = [[MOTimerProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) loopTime:self.time bgColor:[ChangeColorManager getColorWithColorString:self.detailModel.titlecolor]];
    //[ChangeColorManager getColorWithColorString:self.detailModel.titlecolor]
    [self.view addSubview:self.progressView];
    self.progressView.layer.backgroundColor = [UIColor redColor].CGColor;
    
    
    //    MOTimerProgressView *testView = [[MOTimerProgressView alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 80) loopTime:10 bgColor:[UIColor orangeColor]];
    //    [self.view addSubview:testView];
    
    
    //    [[NSRunLoop mainRunLoop] addTimer:self.progressView.timer forMode:@"123"];
    
    
    
    
    //    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    testBtn.frame = CGRectMake(0, 100, 100, 30);
    //    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
    //    [testBtn addTarget:self action:@selector(ceshi) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:testBtn];
}

- (void)jishi {
    NSLog(@"计时");
}

- (void)ceshi {
    
    NSLog(@"测试");
}

- (void)back {
    
    //    [self.timer invalidate];
    //    self.timer = nil;
    [self.progressView.timer invalidate];
    self.progressView.timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
