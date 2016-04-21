//
//  LoginViewController.m
//  No!Fat
//
//  Created by 莫大宝 on 16/4/19.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "UserModel.h"
#import "UserInfoManager.h"
//如果要使用MD5算法进行加密，需要引入此框架
#import <CommonCrypto/CommonCrypto.h>

@interface LoginViewController ()
// 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
// 密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation LoginViewController

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

//  登录
- (IBAction)login:(id)sender {
    
    // 将密码转换成MD5
    NSString *password = [self getMDFiveString:self.passwordTF.text];
    
    // 网络请求
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:LOGINURL parameters:@{@"mobile":self.phoneNumberTF.text, @"password":password} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        // 获取返回状态
        NSNumber *result = responseObject[@"status"];
        // 根据返回状态判断是否登录成功
        if (result.intValue) {// 如果成功
            NSDictionary *userDic = responseObject[@"user"];
//            UserModel *user = [[UserModel alloc] init];
//            [user setValuesForKeysWithDictionary:responseObject[@"user"]];
            [[UserInfoManager shareInstance] saveUserName:userDic[@"username"]];
            [[UserInfoManager shareInstance] saveUserAvatar:userDic[@"avatar"]];
            [[UserInfoManager shareInstance] saveUserID:userDic[@"id"]];
            [[UserInfoManager shareInstance] saveUserGender:userDic[@"gender"]];
            [[UserInfoManager shareInstance] saveUserMobile:userDic[@"mobile"]];
            
            
        } else {// 如果登录失败
            NSLog(@"message = %@",responseObject[@"message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

//  注册
- (IBAction)regist:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    registVC.mobilBlock = ^(NSString *mobile) {
        self.phoneNumberTF.text = mobile;
    };
    [self.navigationController pushViewController:registVC animated:YES];
    
}

//  返回
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
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
