//
//  AddTrainDescViewController.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/28.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddTrainDescViewController.h"
#import "TodayDoneDB.h"
#import "TodayDoneModel.h"
#import "ShareLifeViewController.h"

@interface AddTrainDescViewController ()

@property (nonatomic, strong) UITextField *trainNameTF;// 训练名称
@property (nonatomic, strong) UITextField *trainDescTF;// 训练量
@property (nonatomic, strong) UILabel *trainNameLabel;
@property (nonatomic, strong) TodayDoneDB *db;

@end

@implementation AddTrainDescViewController

- (TodayDoneDB *)db {
    if (!_db) {
        self.db = [[TodayDoneDB alloc] init];
    }
    return _db;
}

// 创建label和textfield并布局
- (void)createLabelAndTextField {
    
    UIFont *labelFont = [UIFont systemFontOfSize:13];
    UIFont *tfFont = [UIFont systemFontOfSize:12];
    CGFloat margin = 10;
    CGFloat nameLHeight = 40;
    CGFloat nameLWidth = [UILabel getWidthWithTitle:@"训练名称" font:labelFont];
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(margin, kNavigationBarHeight, nameLWidth, nameLHeight)];
    nameL.text = @"训练名称";
    nameL.font = labelFont;
    [self.view addSubview:nameL];
    
    CGFloat trainNameX = nameL.frame.origin.x + nameLWidth + margin;
    CGFloat trainNameY = kNavigationBarHeight;
    CGFloat trainNameWidth = kScreenWidth - trainNameX;
    CGFloat trainNameHeight = nameLHeight;
    if (self.trainName) {// 如果有训练名称传过来则显示label
        self.trainNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(trainNameX, trainNameY, trainNameWidth, trainNameHeight)];
        self.trainNameLabel.text = self.trainName;
        self.trainNameLabel.font = labelFont;
        [self.view addSubview:self.trainNameLabel];
    } else {// 如果没有训练名称传过来则显示textfield
        self.trainNameTF = [[UITextField alloc] initWithFrame:CGRectMake(trainNameX, trainNameY, trainNameWidth, trainNameHeight)];
        self.trainNameTF.placeholder = @"请输入训练名称(最长10个字)";
        self.trainNameTF.font = tfFont;
        self.trainNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.view addSubview:self.trainNameTF];
    }
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(margin, kNavigationBarHeight + nameLHeight - 1, kScreenWidth - margin, 1)];
    lineOne.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineOne];
    
    UILabel *trainD = [[UILabel alloc] initWithFrame:CGRectMake(margin, kNavigationBarHeight + nameLHeight, nameLWidth, nameLHeight)];
    trainD.text = @"训练量";
    trainD.font = labelFont;
    [self.view addSubview:trainD];
    
    
    self.trainDescTF = [[UITextField alloc] initWithFrame:CGRectMake(trainNameX, trainNameY + trainNameHeight, trainNameWidth, trainNameHeight)];
    self.trainDescTF.placeholder = @"请输入训练量(最长10个字)";
    self.trainDescTF.font = tfFont;
    self.trainDescTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.trainDescTF];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(margin, kNavigationBarHeight + nameLHeight - 1 + trainNameHeight, kScreenWidth - margin, 1)];
    lineTwo.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineTwo];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"增加训练描述";
    
    // 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    // 下一步按钮
    CGFloat width = [UILabel getWidthWithTitle:@"下一步" font:[UIFont systemFontOfSize:13]];
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, 0, width, 20);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
    self.navigationItem.rightBarButtonItem = nextItem;
    
    
    [self createLabelAndTextField];// 创建label和textfield并布局
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKey:)];
    [self.view addGestureRecognizer:tap];
    
    
    // Do any additional setup after loading the view.
}

- (void)returnKey:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)back {
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)next {
    NSLog(@"next");
    
    if (/*self.trainNameTF.text.length > 0 && */self.trainDescTF.text.length > 0) {
        if (!self.trainName) {
            if (self.trainNameTF.text.length > 0) {
                TodayDoneModel *model = [[TodayDoneModel alloc] init];
                model.desc = self.trainNameTF.text;
                [self.db insertTodayDoneModel:model];
                ShareLifeViewController *shareVC = [[ShareLifeViewController alloc] init];
                shareVC.isTrain = YES;
                shareVC.trainName = self.trainNameTF.text;
                shareVC.trainDesc = self.trainDescTF.text;
                
                [self.navigationController pushViewController:shareVC animated:YES];
                NSArray *array = self.navigationController.viewControllers;
                NSArray *nowArray = @[array[0], array[3]];
                self.navigationController.viewControllers = nowArray;
            }
            
        } else {
            ShareLifeViewController *shareVC = [[ShareLifeViewController alloc] init];
            shareVC.isTrain = YES;
            shareVC.trainName = self.trainName;
            shareVC.trainDesc = self.trainDescTF.text;
            
            [self.navigationController pushViewController:shareVC animated:YES];
            NSArray *array = self.navigationController.viewControllers;
            NSArray *nowArray = @[array[0], array[3]];
            self.navigationController.viewControllers = nowArray;
        }
        
    }
    
    
    
    
    
    
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
