//
//  ShareLifeViewController.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "ShareLifeViewController.h"
#import "PlaceHolderTextView.h"

@interface ShareLifeViewController ()

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) PlaceHolderTextView *placeTextView;

@end

@implementation ShareLifeViewController

- (void)createTextView {
//    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight * 0.4)];
//    [self.view addSubview:self.textView];
    // 测试
//    self.trainName = @"默契";
//    self.trainDesc = @"哈哈哈哈";
    
    self.placeTextView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight * 0.4) isTrain:self.isTrain trainName:self.trainName trainDesc:self.trainDesc];
    [self.view addSubview:self.placeTextView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    self.navigationItem.title = @"发布动态";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 0, 30, 30);
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"publish"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishNews) forControlEvents:UIControlEventTouchUpInside]
    ;
    UIBarButtonItem *publishItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.navigationItem.rightBarButtonItem = publishItem;
    [self createTextView];
    
    
    // Do any additional setup after loading the view.
}

//  返回
- (void)back {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定不发布动态了吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

//  发表打卡动态
- (void)publishNews {
    NSLog(@"动态");
    if (_isTrain == NO) {//如果是分享生活
        if (!self.placeTextView.isPublic) {//如果是加密的
            //给token加码
            NSString *token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
            
            NSString *str = [@"http://api.fit-time.cn/ftsns/dakaShareLife" stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:str parameters:@{@"content":_placeTextView.textView.text,@"priv":@(1)} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject%@", responseObject);
                NSNumber *status = responseObject[@"status"];
                if ([status intValue]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"message%@", error);
            }];

        }else {//公开的
            //给token加码
            NSString *token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
            
            NSString *str = [@"http://api.fit-time.cn/ftsns/dakaShareLife" stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:str parameters:@{@"content":_placeTextView.textView.text} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"responseObject%@", responseObject);
                NSNumber *status = responseObject[@"status"];
                if ([status intValue]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"message%@", error);
            }];
            

        }
        
    }else {//如果是打卡的
    
    if (!self.placeTextView.isPublic) {//如果是加密的
    //给token加码
    NSString *token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    
    NSString *str = [@"http://api.fit-time.cn/ftsns/dakaCustomTraining" stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:str parameters:@{@"training_volume":_trainDesc, @"training_type":_trainName, @"content":_placeTextView.textView.text,@"priv":@(1)} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        NSNumber *status = responseObject[@"status"];
        if ([status intValue]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"message%@", error);
    }];
    }else {//公开的
        //给token加码
        NSString *token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
        
        NSString *str = [@"http://api.fit-time.cn/ftsns/dakaCustomTraining" stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:str parameters:@{@"training_volume":_trainDesc, @"training_type":_trainName, @"content":_placeTextView.textView.text} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject%@", responseObject);
            NSNumber *status = responseObject[@"status"];
            if ([status intValue]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"message%@", error);
        }];

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
