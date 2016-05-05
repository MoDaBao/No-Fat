//
//  AddPersonModelCell.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddPersonModelCell.h"
#import "AddPersonModel.h"
#import "UIImage+ImageEffects.h"

@implementation AddPersonModelCell

- (void)setDataWithModel:(AddPersonModel *)model {
    
    //内容图片
    if ([model.avatar hasPrefix:@"http"]) {
         [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    }else if (!model.avatar){
        self.avatar.image = [UIImage imageNamed:@"111.jpeg"];
    }else{
        
    NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
    NSString *imageName = [arr lastObject];
    
    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small", imageName];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //创建模糊view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.userNameLabel.frame;
    effectView.frame = CGRectMake(0, self.userNameLabel.frame.origin.y, self.userNameLabel.frame.size.width, 26);
    [self.avatar addSubview:effectView];
    self.userNameLabel.text = model.username;
    
}


//关注按钮方法
- (IBAction)GUANZHU:(id)sender {
    
    
}

@end
