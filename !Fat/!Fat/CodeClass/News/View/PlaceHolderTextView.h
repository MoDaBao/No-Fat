//
//  PlaceHolderTextView.h
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, copy) NSString *content;// textView上的内容
@property (nonatomic, strong) UIButton *publicBtn;// 改变公开或者私密的按钮
@property (nonatomic, strong) UILabel *publicLabel;// 显示公开或者字谜
@property (nonatomic, strong) UIImageView *publicImageView;//
@property (nonatomic, strong) UILabel *descLabel;// 对私密或公开的描述
@property (nonatomic, assign) NSInteger isPublic;// 判断是否改变
//@property (nonatomic, copy) NSString *trainName;// 训练名称
//@property (nonatomic, copy) NSString *trainDesc;// 训练描述
@property (nonatomic, strong) UILabel *trainLabel;


- (instancetype)initWithFrame:(CGRect)frame isTrain:(BOOL)isTrain trainName:(NSString *)trainName trainDesc:(NSString *)trainDesc;

@end
