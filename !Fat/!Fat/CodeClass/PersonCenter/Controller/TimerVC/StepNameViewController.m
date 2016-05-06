//
//  StepNameViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/5/4.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "StepNameViewController.h"

@interface StepNameViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation StepNameViewController

- (void)createTextField {
    
    CGFloat margin = 15;
    CGFloat height = 30;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 400, kScreenWidth, height)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, contentView.width - margin * 2, height)];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.text = self.stepName;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:self.textField];
    [self.textField becomeFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        contentView.y = 100;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    [self createTextField];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

- (void)back {
    self.passValue(self.textField.text);
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
