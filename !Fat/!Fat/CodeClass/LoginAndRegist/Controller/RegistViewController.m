//
//  RegistViewController.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "RegistViewController.h"
//如果要使用MD5算法进行加密，需要引入此框架
#import <CommonCrypto/CommonCrypto.h>
#import "LoginViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation RegistViewController

//  返回
- (IBAction)back:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  获取MD5字符串
- (NSString *)getMDFiveString:(NSString *)string {
    //准备字符串
    //    NSString *string = @"are you a pig?";
    
    //将OC字符串转换成C语言字符串
    const char *str = [string UTF8String];
    
    //创建一个存储MD5值的数组
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //计算MD5值，字符串加密计算值可以采用以下这个函数
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    //    printf("%s",result);
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithCapacity:0];
    
    //遍历result数组，得到里面的所有的数据（MD5值）
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [mStr appendFormat:@"%02x",result[i]];
    }
    
    NSLog(@"%@",mStr);
    return [mStr lowercaseString];
}

//  获取验证码
- (IBAction)getVerifyCode:(id)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:VERIFYCODEURL parameters:@{@"mobile":self.phoneNumberTF.text} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];

}

//  注册
- (IBAction)regist:(id)sender {
    if (!self.verifyCodeTF.text) {
        // 提示用户验证码不能为空
        
        NSLog(@"验证码为空");
    } else {
        if (self.passwordTF.text.length >= 6) {
            // 将密码转化成MD5
            NSString *password = [self getMDFiveString:self.passwordTF.text];
            // 网络请求
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:REGISTURL parameters:@{@"password":password, @"mobile":self.phoneNumberTF.text, @"code":self.verifyCodeTF.text} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                NSNumber *result = responseObject[@"status"];
                if (result.intValue) {// 注册成功
                    self.mobilBlock(responseObject[@"user"][@"mobile"]);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {// 注册失败
                    NSLog(@"message = %@",responseObject[@"message"]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error %@",error);
            }];
        } else {
            NSLog(@"密码格式不正确");
        }
    }
    
    
}

//  返回账号登录页面
- (IBAction)backLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
