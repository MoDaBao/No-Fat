//
//  ComentListViewController.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/4/29.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "ComentListViewController.h"
#import "RecommendDetailModelCell.h"
#import "WriteCommentView.h"

@interface ComentListViewController ()<UITableViewDataSource, UITableViewDelegate, KeyBoardViewDelegate>

@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WriteCommentView *commentView;

@property (nonatomic, copy) CGFloat(^CellHeightBlock)();
@property (nonatomic, strong) KeyBoardView *keyView;

@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic) NSInteger start;

@end

@implementation ComentListViewController

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
    
    //导航栏的的返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    [self createTableView];
    [self requsetData];
    [self createCommentView];
    


    // Do any additional setup after loading the view.
}

//点击空白处回收键盘的方法
-(void)keyboardHide1:(UITapGestureRecognizer*)tap1{
    [self.keyView.textView resignFirstResponder];
}

//- (void)clickButton:(UIButton *)sender {
//    if (sender == _commentView.commentBT) {
//        NSLog(@"点击了评论");
//        if(self.keyView==nil){
//            self.keyView=[[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
//        }
//        //  设置键盘输入框
//        self.keyView.delegate=self;
//        [self.keyView.textView becomeFirstResponder];
//        self.keyView.textView.returnKeyType = UIReturnKeySend;
//        
//        [self.view addSubview:self.keyView];
//    }
//}
#pragma mark-----请求评论数据-------
- (void)requsetData {
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshFeedComments?feed_id=%@", _feedId] dic:@{} finish:^(NSData *data) {
        NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic%@", dic);
        
        NSLog(@"_feedId%@", _feedId);
        if (_start == 0) {
            [self.listArr removeAllObjects];
        }
        
        
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

#pragma mark ------设置底部评论按钮------
- (void)createCommentView {
  
    _commentView = [[[NSBundle mainBundle] loadNibNamed:@"WriteCommentView" owner:nil options:nil] lastObject];
    _commentView.frame = CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40);
    [_commentView.writeCommentBT addTarget:self action:@selector(commentBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentView];
    
}

- (void)commentBT:(UIButton *)sender {
    if(self.keyView==nil){
    self.keyView=[[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        }
    //  设置键盘输入框
     self.keyView.delegate=self;
    [self.keyView.textView becomeFirstResponder];
    self.keyView.textView.returnKeyType = UIReturnKeySend;

    [self.view addSubview:self.keyView];
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


- (void)back {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark----创建tableView---
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 90) style:UITableViewStylePlain];
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
    
    RecommendDetailModel *model = self.listArr[indexPath.row];
    
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
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
            cell.headImageView.userInteractionEnabled = YES;
            [cell.headImageView addGestureRecognizer:tap1];
            
            cell.userNameLabel.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];
    
    self.CellHeightBlock = ^{
        return cell.cellHeight;
    };
    return cell;
}

- (void)tap1:(UIGestureRecognizer *)tap1 {
    
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
