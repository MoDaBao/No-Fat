//
//  MyNewsViewController.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "MyNewsViewController.h"

@interface MyNewsViewController ()

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    label.text = @"我的动态";
    self.navigationItem.titleView = label;
    
    // Do any additional setup after loading the view.
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
