//
//  AddTimeDetailViewController.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddTimeDetailViewController.h"
#import "AddtimeDetailHeaderView.h"
#import "RecommendDetailModelCell.h"
#import "RecommendDetailModel.h"
#import "CommentView.h"
#import "AddtimeDetailNoImageHeaderView.h"

@interface AddTimeDetailViewController ()<UITableViewDataSource, UITableViewDelegate,CommentViewDelegate, KeyBoardViewDelegate>


@property (nonatomic, strong)AddtimeDetailHeaderView *addtimeDetailHeaderView;
@property (nonatomic, strong)AddtimeDetailNoImageHeaderView *addtimeDetailNoImageHeaderView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) CGFloat(^CellHeightBlock)();
@property (nonatomic, strong) CommentView *commentView;

@property (nonatomic, strong) KeyBoardView *keyView;

@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic) NSInteger start;
@end

@implementation AddTimeDetailViewController

//push过来隐藏tabbar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (NSMutableArray *)listArr {
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动态详情";
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    //键盘将要显示的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘要隐藏的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //点击view空白处的回收键盘的手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide1:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
    [self requsetData];
    [self createTableView];
    [self selectHeaderView];
    [self createCommentView];
    // Do any additional setup after loading the view from its nib.
}

//点击空白处回收键盘的方法
-(void)keyboardHide1:(UITapGestureRecognizer*)tap1{
    [self.keyView.textView resignFirstResponder];
}



#pragma mark ----底部评论的那个------
- (void)createCommentView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    _commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
    _commentView.frame = view.bounds;
    _commentView.delegate = self;//设置代理
    [view addSubview:_commentView];
    [self.view addSubview:view];
    
}


//  键盘显示的方法
-(void)keyboardShow:(NSNotification *)note {
    //  获取键盘的大小
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
//  键盘隐藏的方法
-(void)keyboardHide:(NSNotification *)note {
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyView.textView.text=@"";
        [self.keyView removeFromSuperview];
    }];
}

//  输入框的代理方法
-(void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView {
    [contentView resignFirstResponder];
    //发送评论的接口请求
    [self requestSendComment:contentView.text];
    NSLog(@"contentView%@", contentView.text);
}


// 发表评论
- (void)requestSendComment:(NSString *)comment {
    
    [NetWorkRequestManager requestWithType:POST url:@"http://api.fit-time.cn/ftsns/commentFeed?token=r1VPsKaxR4f1WzZE2ptiH08oX48WySziUW71BT7ugcdsrFTIr%2BerBw%3D%3D&device_id=FDB8955C-1AD4-45AA-9297-150E8574177B" dic:@{@"feed_id":_feedId, @"comment":comment, @"author_id":[[UserInfoManager shareInstance] getUserID]} finish:^(NSData *data) {
        

        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        NSNumber *result = [dic objectForKey:@"status"];
        NSLog(@"%@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue] == 1) {
                if (_start == 0) {
                    [self requsetData];
                    
                }
            }
            
        });
        
    } error:^(NSError *error) {
        
    }];
    
}



- (void)clickButton:(UIButton *)sender {
    if (sender == _commentView.commentBT) {
        NSLog(@"点击了评论");
        if(self.keyView==nil){
            self.keyView=[[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        }
        //  设置键盘输入框
        self.keyView.delegate=self;
        [self.keyView.textView becomeFirstResponder];
        self.keyView.textView.returnKeyType = UIReturnKeySend;
        
        [self.view addSubview:self.keyView];
    }else if (sender == _commentView.praiseBT) {
        
        //        [self requestPraise];
        
        
        NSLog(@"点击了点赞");
    }else {
        NSLog(@"分享");
    }
}

// 选择创建哪个头视图
- (void)selectHeaderView {
    
    if (_model.image) {
        [self createHeaderView];
    }else {
        [self createNoImageHeaderView];
    }
}





#pragma merk---创建头视图------
- (void)createHeaderView {
    
    _addtimeDetailHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"AddtimeDetailHeaderView" owner:nil options:nil] lastObject];
    _addtimeDetailHeaderView.frame = CGRectMake(0, 0, ScreenWidth, self.textHeight);

    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",_model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [_addtimeDetailHeaderView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            }else if ([model.avatar isEqualToString:@""]) {
                _addtimeDetailHeaderView.headImageView.image = [UIImage imageNamed:@"111.jpeg"];

            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
                
                [_addtimeDetailHeaderView.headImageView sd_setImageWithURL:[NSURL URLWithString:image]];
                
                //给头像加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                _addtimeDetailHeaderView.headImageView.userInteractionEnabled = YES;
                [_addtimeDetailHeaderView.headImageView addGestureRecognizer:tap];
              


            }
            _addtimeDetailHeaderView.contentLabel.text = _model.content;
            NSNumber *createTime = _model.createTime;
            NSDate *date = [NSDate date];
            NSInteger time = [date timeIntervalSince1970];
            NSInteger space = time - createTime.integerValue / 1000;
            NSInteger spacetime = space / (60 * 60);
            if (spacetime < 24 & spacetime > 0) {
                _addtimeDetailHeaderView.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",spacetime];
            } else if (spacetime < 1) {
                _addtimeDetailHeaderView.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",space / 60];
            } else {
                //        double time = [[dic.allValues firstObject] doubleValue] / 1000;
                //        CGFloat year = time /
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime.integerValue / 1000];
                //将一个日期对象转化为字符串对象
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //设置日期与字符串互转的格式
                [formatter setDateFormat:@"yyyy-MM-dd"];
                //将日期转化为字符串
                NSString *dateStr = [formatter stringFromDate:date];
                _addtimeDetailHeaderView.timeLabel.text = dateStr;
            }

            _addtimeDetailHeaderView.nameLabel.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];
    
    //切割字符串 拼接图片
    NSArray *arr = [_model.image componentsSeparatedByString:@"/"];
    NSString *imageName = [arr lastObject];
    
    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!320", imageName];
    
    [_addtimeDetailHeaderView.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    
    self.tableView.tableHeaderView = _addtimeDetailHeaderView;
}



- (CGFloat)textHeight
{
    if (_model.image) {
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
        CGFloat textH = [_model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        //计算
        return CGRectGetMinY(_addtimeDetailHeaderView.contentLabel.frame)+ CGRectGetMaxY(_addtimeDetailHeaderView.contentImageView.frame) + textH;
    }else {
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
        CGFloat textH = [_model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
        //计算
        return CGRectGetMinY(_addtimeDetailNoImageHeaderView.contentLabel.frame)+ CGRectGetMaxY(_addtimeDetailNoImageHeaderView.progromBT.frame) + textH;

    }
    
}

#pragma merk---创建头视图------
- (void)createNoImageHeaderView {
    
    _addtimeDetailNoImageHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"AddtimeDetailNoImageHeaderView" owner:nil options:nil] lastObject];
    _addtimeDetailNoImageHeaderView.frame = CGRectMake(0, 0, ScreenWidth, self.textHeight);
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",_model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [_addtimeDetailNoImageHeaderView.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            }else if ([model.avatar isEqualToString:@""]) {
                _addtimeDetailNoImageHeaderView.headerImageView.image = [UIImage imageNamed:@"111.jpeg"];
                
            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
                [_addtimeDetailNoImageHeaderView
                 .headerImageView sd_setImageWithURL:[NSURL URLWithString:image]];
                //给头像加手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                _addtimeDetailNoImageHeaderView.headerImageView.userInteractionEnabled = YES;
                [_addtimeDetailNoImageHeaderView.headerImageView addGestureRecognizer:tap];
                
               
                
            }
            _addtimeDetailNoImageHeaderView.contentLabel.text = _model.content;
            
            NSNumber *createTime = _model.createTime;
            NSDate *date = [NSDate date];
            NSInteger time = [date timeIntervalSince1970];
            NSInteger space = time - createTime.integerValue / 1000;
            NSInteger spacetime = space / (60 * 60);
            if (spacetime < 24 & spacetime > 0) {
                _addtimeDetailNoImageHeaderView.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",spacetime];
            } else if (spacetime < 1) {
                _addtimeDetailNoImageHeaderView.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",space / 60];
            } else {
                //        double time = [[dic.allValues firstObject] doubleValue] / 1000;
                //        CGFloat year = time /
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime.integerValue / 1000];
                //将一个日期对象转化为字符串对象
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //设置日期与字符串互转的格式
                [formatter setDateFormat:@"yyyy-MM-dd"];
                //将日期转化为字符串
                NSString *dateStr = [formatter stringFromDate:date];
                _addtimeDetailNoImageHeaderView.timeLabel.text = dateStr;
            }
            _addtimeDetailNoImageHeaderView.nameLabel.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];
    
   
    self.tableView.tableHeaderView = _addtimeDetailNoImageHeaderView;
}





// 给头像加手势  跳转到个人信息
- (void)tap:(UIGestureRecognizer *)tap {
    
    UserMessageViewController *userVC = [[UserMessageViewController alloc] init];
    userVC.userId = _model.userId;
    [self.navigationController pushViewController:userVC animated:YES];
    
    
}

#pragma mark-----请求数据-------
- (void)requsetData {
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshFeedComments?feed_id=%@", _feedId] dic:@{} finish:^(NSData *data) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        
        if (_start == 0) {
            [self.listArr removeAllObjects];
        }

        NSLog(@"dic%@", dic);
        
        NSArray *arr = dic[@"comments"];
        NSLog(@"%@", arr);
        for (NSDictionary *headDic in arr) {
            RecommendDetailModel *model = [[RecommendDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:headDic];
            [self.listArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
}
#pragma mark----创建tableView---
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RecommendDetailModelCell" bundle:nil] forCellReuseIdentifier:@"RecommendDetailModelCell"];
    
}
#pragma mark-----tableView代理方法-----
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10; // you can have your own choice, of course
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddTimeListModel *model = self.listArr[indexPath.row];
    
    RecommendDetailModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendDetailModelCell" forIndexPath:indexPath];
    [cell setDataWithModel:model];
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:image]];
            }
            
            cell.userNameLabel.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];
    
    self.CellHeightBlock = ^{
        return cell.cellHeight;
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    AttentionDetailViewController *attentionVC = [[AttentionDetailViewController alloc] init];
    //    [_parent.navigationController pushViewController:attentionVC animated:YES];
    //
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.CellHeightBlock) {
        return self.CellHeightBlock();
    }else{
        return .0f;
    }
}

- (void)back {
    
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
