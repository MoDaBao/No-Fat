//
//  AttentionDetailViewController.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AttentionDetailViewController.h"
#import "RecommendDetailHeadView.h"
#import "RecommendDetailModelCell.h"
#import "RecommendDetailModel.h"
#import "CommentView.h"
#import "UserMessageViewController.h"


@interface AttentionDetailViewController ()<UITableViewDataSource, UITableViewDelegate, CommentViewDelegate, KeyBoardViewDelegate>


@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) CGFloat(^CellHeightBlock)();
@property (nonatomic, strong) RecommendDetailHeadView *recommendDetailHeadView;
@property (nonatomic, strong) CommentView *commentView;

@property (nonatomic, strong) KeyBoardView *keyView;

@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic) NSInteger start;

@end

@implementation AttentionDetailViewController

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
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
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
    [self createHeaderView];
    [self createCommentView];
    // Do any additional setup after loading the view from its nib.
}

//点击空白处回收键盘的方法
-(void)keyboardHide1:(UITapGestureRecognizer*)tap1{
    [self.keyView.textView resignFirstResponder];
}


- (void)back {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma merk---创建头视图------
- (void)createHeaderView {
    
    _recommendDetailHeadView = [[[NSBundle mainBundle] loadNibNamed:@"RecommendDetailHeadView" owner:nil options:nil] lastObject];
    _recommendDetailHeadView.frame = CGRectMake(0, 0, ScreenWidth, self.textHeight);
    
    
    //    [_recommendDetailHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
    //    _recommendDetailHeadView.nameLabel.text = @"zhongji";
    
    
    //个人的信息的获取
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",_model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [_recommendDetailHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.image]];
            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small2", imageName];
                
                [_recommendDetailHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:image]];
                
            }
           //  赋值
            _recommendDetailHeadView.contentLabel.text = _model.content;
            _recommendDetailHeadView.timeLabel.text = [NSString stringWithFormat:@"%@", _model.createTime];
            _recommendDetailHeadView.nameLabel.text = model.username;
            
            //给头像加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            _recommendDetailHeadView.headImageView.userInteractionEnabled = YES;
            [_recommendDetailHeadView.headImageView addGestureRecognizer:tap];
            
        });
    } error:^(NSError *error) {
        
    }];
    
    //切割字符串 拼接图片
    NSArray *arr = [_model.image componentsSeparatedByString:@"/"];
    NSString *imageName = [arr lastObject];
    
    NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!320", imageName];
    
    [_recommendDetailHeadView.contentImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    
    self.tableView.tableHeaderView = _recommendDetailHeadView;
}

// 给头像加手势  跳转到个人信息
- (void)tap:(UIGestureRecognizer *)tap {

    UserMessageViewController *userVC = [[UserMessageViewController alloc] init];
    userVC.userId = _model.userId;
    [self.navigationController pushViewController:userVC animated:YES];
    
    
}

// 计算字符串的高度
- (CGFloat)textHeight
{
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
    CGFloat textH = [_model.content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height;
    //计算
    return CGRectGetMinY(_recommendDetailHeadView.contentLabel.frame)+ CGRectGetMaxY(_recommendDetailHeadView.contentImageView.frame) + textH + 20  ;
}


#pragma mark ----底部评论的那个------
- (void)createCommentView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    _commentView = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:nil options:nil] lastObject];
    _commentView.frame = view.bounds;
    _commentView.delegate = self;
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


#pragma mark----创建tableView---
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 50) style:UITableViewStylePlain];
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
    
    AttentionListModel *model = self.listArr[indexPath.row];
    
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
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    cell.headImageView.userInteractionEnabled = YES;
    [cell.headImageView addGestureRecognizer:tap1];
    
    self.CellHeightBlock = ^{
        return cell.cellHeight;
    };
    return cell;
}


//点击评论的人的头像跳转到个人信息
- (void)tap1:(UIGestureRecognizer *)tap {
    
    _detailModel = [[RecommendDetailModel alloc] init];
    UserMessageViewController *userVC = [[UserMessageViewController alloc] init];
    userVC.userId = _detailModel.ID;
    [self.navigationController pushViewController:userVC animated:YES];
    
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
