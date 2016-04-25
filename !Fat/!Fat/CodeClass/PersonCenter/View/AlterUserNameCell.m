//
//  AlterUserNameCell.m
//  !Fat
//
//  Created by 莫大宝 on 16/4/23.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "AlterUserNameCell.h"

@implementation AlterUserNameCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        CGFloat margin = 10;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, kScreenWidth - margin * 2, self.frame.size.height)];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.placeholder = @"取一个你喜欢的昵称吧，2-15个字";
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    NSLog(@"23333");
//    NSString * token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
////    NSString *token = [[UserInfoManager shareInstance] getUserToken];
//    NSString *urlString = [ALTERUSERINFOURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]];
    NSString *urlString = [NSString GetURLEncodeWithUserToken];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlString parameters:@{@"username":self.textField.text} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"status"];
        if (result.intValue) {
            [[UserInfoManager shareInstance] saveUserName:self.textField.text];
            self.passValue(self.textField.text);
        } else {
            NSLog(@"message = %@",responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return YES;
}

@end
