//
//  NewViewController.m
//  No! Fat
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "NewViewController.h"
#import "ButtonView.h"
#import "RecommendView.h"
#import "AttentionView.h"
#import "addTimeView.h"
#import "RecommendCollectionReusableView.h"
#import "SearchViewController.h"
#import "AddNewsView.h"
#import "TwoItemView.h"
#import "ShareLifeViewController.h"
#import "TodayDoneViewController.h"

@interface NewViewController ()<ButtonViewDelegete>

@property (nonatomic, strong) ButtonView *buttonView;
@property (nonatomic, strong) AttentionView *attentionView;
@property (nonatomic, strong) RecommendView *recommendView;
@property (nonatomic, strong) addTimeView *addtimeView;
//@property (nonatomic, strong) RecommendCollectionReusableView *recommendCollectionReusableView;

//@property (nonatomic, strong) NSArray *dataArr;
//@property (nonatomic, strong) BaseViewController *baseVC;
//@property (nonatomic, strong) UINavigationController *naVC;
@property (nonatomic, strong) AddNewsView *addNewsView;
@property (nonatomic, strong) TwoItemView *twoItemView;

@end

@implementation NewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.addNewsView) {
        CGFloat margin = 20;
        CGFloat addViewWidth = 50;
        CGFloat addViewHeight = addViewWidth;
        CGFloat addViewX = kScreenWidth - addViewWidth - margin;
        CGFloat addViewY = kScreenHeight - kTabBarHeight - margin - addViewHeight;
        self.addNewsView = [[AddNewsView alloc] initWithFrame:CGRectMake(addViewX, addViewY, addViewWidth, addViewHeight)];
        [self.addNewsView.addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:self.addNewsView];
    }
    
}

- (void)add {
    NSLog(@"2333");
    
    //    [UIView animateWithDuration:.2 animations:^{
    ////        self.backgroundColor = [UIColor colorWithRed:0.55 green:0.48 blue:0.12 alpha:1.00];
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    self.twoItemView = [[TwoItemView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.twoItemView.trainView.trainBtn addTarget:self action:@selector(train) forControlEvents:UIControlEventTouchUpInside];
    [self.twoItemView.lifeView.lifeBtn addTarget:self action:@selector(life) forControlEvents:UIControlEventTouchUpInside];
    self.twoItemView.alpha = .0;
    [self.navigationController.view addSubview:self.twoItemView];
    
    [UIView animateWithDuration:.3 animations:^{
        self.twoItemView.alpha = 1.0;
    }];
    
    
}

- (void)train {
    NSLog(@"23333");
    TodayDoneViewController *todayVC = [[TodayDoneViewController alloc] init];
    [UIView animateWithDuration:.3 animations:^{
        [self.navigationController pushViewController:todayVC animated:YES];
        self.twoItemView.alpha = .0;
    } completion:^(BOOL finished) {
        [self.twoItemView removeFromSuperview];
    }];
}

- (void)life {
    NSLog(@"6666");
    ShareLifeViewController *shareVC = [[ShareLifeViewController alloc] init];
    //    shareVC.isTrain = YES;
    shareVC.isTrain = NO;
    [UIView animateWithDuration:.3 animations:^{
        [self.navigationController pushViewController:shareVC animated:YES];
        self.twoItemView.alpha = .0;
    } completion:^(BOOL finished) {
        [self.twoItemView removeFromSuperview];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"!Fat动态";
    [self createButton];
   _recommendView = [[RecommendView alloc] initWithFrame:CGRectMake(0,114, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_recommendView];
    
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"sousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.recommendView.parent = self;

       // Do any additional setup after loading the view from its nib.
}
- (void)search {
    
//    SearchFirstViewController *searchVC = [[SearchFirstViewController alloc] init];
//    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
//    SearchViewController *searchVC = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self presentViewController:searchVC animated:YES completion:nil];
//    [self presentViewController:naVC animated:YES completion:nil];
    
    
}



#pragma mark------页面上面的按钮-------
- (void)createButton {

    ButtonView *buttonView =[ButtonView buttonView];
    buttonView.delegete = self;
    //    buttonView.backgroundColor = [UIColor redColor];
    buttonView.frame = CGRectMake(0, 80, self.view.frame.size.width, 21);
    [self.view addSubview:buttonView];
    self.buttonView = buttonView;
}



#pragma mark - ButtonViewDelegete
- (void)didClickButton:(UIButton *)sender


{
    if (sender == self.buttonView.tuijian) {
        //点击了推荐按钮做的事情
        NSLog(@"推荐按钮");
       
//        [self.buttonView.tuijian setBackgroundColor:[UIColor grayColor]];
      
    
        //删除子视图
        for (UIView *view in self.view.subviews) {
            if (view == self.recommendView || self.addtimeView ||self.attentionView) {
                [view removeFromSuperview];
           
            }
            _recommendView = [[RecommendView alloc] initWithFrame:CGRectMake(0,114, self.view.frame.size.width, self.view.frame.size.height - 114)];
           
        }
        [self.view addSubview:_buttonView];
        [self.view addSubview:_recommendView];
         self.recommendView.parent = self;
        
    }else if (sender == self.buttonView.guanzhu)
    {
//        [self.buttonView.guanzhu setBackgroundColor:[UIColor grayColor]];
       
        //点击了关注按钮做的事情
        _attentionView = [[AttentionView alloc] initWithFrame:CGRectMake(0, 114,self.view.frame.size.width, self.view.frame.size.height - 114)];

        for (UIView *view in self.view.subviews) {
            if (view == self.recommendView || self.addtimeView ||self.attentionView) {
                [view removeFromSuperview];
            }
            [self.view addSubview:_buttonView];
            [self.view addSubview:_attentionView];
        }
        NSLog(@"关注按钮");
         self.attentionView.parent = self;
    }else if (sender == self.buttonView.zuixin){
        
//        [self.buttonView.zuixin setBackgroundColor:[UIColor grayColor]];
        _addtimeView = [[addTimeView alloc] initWithFrame:CGRectMake(0, 114,self.view.frame.size.width, self.view.frame.size.height - 114)];
        for (UIView *view in self.view.subviews) {
            if (view == self.recommendView || self.addtimeView ||self.attentionView) {
                [view removeFromSuperview];
            }
            [self.view addSubview:_buttonView];
            [self.view addSubview:_addtimeView];
        }
        NSLog(@"最新按钮");
        self.addtimeView.parent = self;
 }
}

//垃圾方法

//推荐
//- (IBAction)recommend:(id)sender {
//    [self createRootView:0];
//    self.view.backgroundColor = [UIColor grayColor];
//}
//- (void)recommend:(UIButton *)sender
//{
//    NSLog(@"点击了推荐~");
//}
//关注
//- (IBAction)attention:(id)sender {
//    
//    [self createRootView:1];
//    self.view.backgroundColor = [UIColor redColor];
//}
//
////最新
//- (IBAction)new:(id)sender {
//}
//
////附近
//- (IBAction)nearby:(id)sender {
//    
//}


//创建button显示的页面
//- (void)createRootView:(NSInteger)index {
//    
//    //删除
//    [self.navigationController.view removeFromSuperview];
//    
//    //创建
//    //按照位置获取控制器的名字
//    NSString *name = self.dataArr[index];
//    //将控制器的名字转换成类名
//    Class class = NSClassFromString(name);
//    //创建控制器对象
//    self.baseVC = [[class alloc] init];
//    self.naVC = [[UINavigationController alloc] initWithRootViewController:self.baseVC];
//    
//    //设置默认的创建的根视图的位置
//    _naVC.view.frame = CGRectMake(200, _naVC.view.frame.origin.y, _naVC.view.frame.size.width, _naVC.view.frame.size.height);
//
//    
//    //将视图控制器的view添加到根视图上
//    [self.baseVC.view addSubview:_baseVC.view];
//    
//}


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
