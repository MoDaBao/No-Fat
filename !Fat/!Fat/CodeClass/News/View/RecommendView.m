//
//  RecommendView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "RecommendView.h"
#import "RecommendViewController.h"
#import "RecommendListModel.h"
#import "FirstTopicViewController.h"
#import "RecommendListModelCell.h"
#import "MyActivityIndicatorView.h"
#import "TwoItemView.h"
#import "TodayDoneViewController.h"
#import "ShareLifeViewController.h"



#define ScreenWidth  [UIScreen mainScreen].bounds.size.width //屏幕宽
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height //屏幕高


@interface RecommendView ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, KeyBoardViewDelegate>//,RecommendCollectionReusableViewDelegete

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) KeyBoardView *keyView;

@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, strong)MyActivityIndicatorView *myActivityIndicatorView;

@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) AddNewsView *addNewsView;
@property (nonatomic, strong) TwoItemView *twoItemView;
@end

@implementation RecommendView

//- (void)viewWillAppear:(BOOL)animated {
//    [self viewWillAppear:animated];
//    if (!self.addNewsView) {
//        CGFloat margin = 20;
//        CGFloat addViewWidth = 50;
//        CGFloat addViewHeight = addViewWidth;
//        CGFloat addViewX = kScreenWidth - addViewWidth - margin;
//        CGFloat addViewY = kScreenHeight - kTabBarHeight - margin - addViewHeight;
//        self.addNewsView = [[AddNewsView alloc] initWithFrame:CGRectMake(addViewX, addViewY, addViewWidth, addViewHeight)];
//        [self.addNewsView.addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
//        [_parent.navigationController.view addSubview:self.addNewsView];
//    }
//    
//}
//
//- (void)add {
//    NSLog(@"2333");
//    
//    //    [UIView animateWithDuration:.2 animations:^{
//    ////        self.backgroundColor = [UIColor colorWithRed:0.55 green:0.48 blue:0.12 alpha:1.00];
//    //    } completion:^(BOOL finished) {
//    //
//    //    }];
//    
//    self.twoItemView = [[TwoItemView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [self.twoItemView.trainView.trainBtn addTarget:self action:@selector(train) forControlEvents:UIControlEventTouchUpInside];
//    [self.twoItemView.lifeView.lifeBtn addTarget:self action:@selector(life) forControlEvents:UIControlEventTouchUpInside];
//    self.twoItemView.alpha = .0;
//    [self.view addSubview:self.twoItemView];
//    
//    [UIView animateWithDuration:.3 animations:^{
//        self.twoItemView.alpha = 1.0;
//    }];
//    
//    
//}
//
//- (void)train {
//    NSLog(@"23333");
//    TodayDoneViewController *todayVC = [[TodayDoneViewController alloc] init];
//    [UIView animateWithDuration:.3 animations:^{
//        [_parent.navigationController pushViewController:todayVC animated:YES];
//        self.twoItemView.alpha = .0;
//    } completion:^(BOOL finished) {
//        [self.twoItemView removeFromSuperview];
//    }];
//}
//
//- (void)life {
//    NSLog(@"6666");
//    ShareLifeViewController *shareVC = [[ShareLifeViewController alloc] init];
//    //    shareVC.isTrain = YES;
//    shareVC.isTrain = NO;
//    [UIView animateWithDuration:.3 animations:^{
//        [_parent.navigationController pushViewController:shareVC animated:YES];
//        self.twoItemView.alpha = .0;
//    } completion:^(BOOL finished) {
//        [self.twoItemView removeFromSuperview];
//    }];
//}

//懒加载
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self requestData];
        
        // 自带菊花方法
        self.myActivityIndicatorView = [[MyActivityIndicatorView alloc]init];
        [self addSubview:_myActivityIndicatorView];
        // 动画开始
        [_myActivityIndicatorView startAnimating];
//        NSLog(@"%@", self.dataArr);
    }
    return self;
}

//请求列表数据
- (void)requestData {
    [NetWorkRequestManager requestWithType:GET url:TUIJIANLIST_URL dic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dic);
        
        NSArray *arr = dic[@"feeds"];
//        NSLog(@"datadic%@", arr);
        
        for (NSDictionary *dataDic in arr) {
            RecommendListModel *model = [[RecommendListModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataArr addObject:model];
//             NSLog(@"%@", dataDic);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 动画结束
            [_myActivityIndicatorView stopAnimating];
            [self createRecommend];
            [self.collectionView reloadData];
        });
       
//         NSLog(@"dataArr%@", _dataArr);
    } error:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
};

//下拉刷新更多
- (void)requestDataMore {
    
//    for (int i = 0; i < self.dataArr.count; i ++) {
     RecommendListModel *model = self.dataArr[self.dataArr.count- 1];
    
    //给token加码
    NSString *token = [[[UserInfoManager shareInstance] getUserToken] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    
    NSString *str = [@"http://api.fit-time.cn/ftsns/loadMoreUserFeed" stringByAppendingString:[NSString stringWithFormat:@"?token=%@&last_id=%@&page_size=20",token, model.ID]];

    [NetWorkRequestManager requestWithType:GET url:str dic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//                NSLog(@"%@", dic);
        
        NSArray *arr = dic[@"feeds"];
                NSLog(@"datadic%@", arr);
        
        for (NSDictionary *dataDic in arr) {
            RecommendListModel *model = [[RecommendListModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataArr addObject:model];
            //             NSLog(@"%@", dataDic);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self.collectionView.mj_footer endRefreshing];
        });
        
        //         NSLog(@"dataArr%@", _dataArr);
    } error:^(NSError *error) {
        NSLog(@"error%@", error);
    }];
};
//}


#pragma mark -----推荐页面-----
- (void)createRecommend {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //item之间的最小间距
    layout.minimumInteritemSpacing = 2;
    //行之间的饿最小间距
    layout.minimumLineSpacing = 2;
    //item的大小
    layout.itemSize = CGSizeMake(ScreenWidth / 2 - 15, ScreenWidth / 2 + 70);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 114) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //增广视图的大小
    CGFloat totalWidth = self.frame.size.width;
    layout.headerReferenceSize = CGSizeMake(totalWidth, 120);
    
    //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"RecommendListModelCell" bundle:nil] forCellWithReuseIdentifier:@"reuse"];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    
    
    //集合视图如果想要分区头视图显示。必须注册增广视图
//    [_collectionView registerClass:[RecommendCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self addSubview:_collectionView];
    
    //上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDataMore)];
    
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
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
    
    
}


//点击空白处回收键盘的方法
-(void)keyboardHide1:(UITapGestureRecognizer*)tap1{
    [self.keyView.textView resignFirstResponder];
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
    
    [NetWorkRequestManager requestWithType:POST url:@"http://api.fit-time.cn/ftsns/commentFeed?token=r1VPsKaxR4f1WzZE2ptiH08oX48WySziUW71BT7ugcdsrFTIr%2BerBw%3D%3D&device_id=FDB8955C-1AD4-45AA-9297-150E8574177B" dic:@{@"comment":comment, @"author_id":[[UserInfoManager shareInstance] getUserID]} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        NSNumber *result = [dic objectForKey:@"status"];
        NSLog(@"%@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue] == 1) {
                NSLog(@"ppp");
            }
            
        });
        
    } error:^(NSError *error) {
        
    }];
    
}


//返回增广视图  也就是集合视图的头视图或者尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    _view = [RecommendCollectionReusableView buttonView];
    //_view.delegate = self;
    _view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    view.backgroundColor = [UIColor yellowColor];
//    view.frame = CGRectMake(0, 0, ScreenWidth, 150);
 
    [_view.firstTopic addTarget:self action:@selector(clickFirstTopic) forControlEvents:UIControlEventTouchUpInside];
    return _view;
}


- (void)clickFirstTopic {
    
    FirstTopicViewController *firstVC = [[FirstTopicViewController alloc] init];
    [self.parent.navigationController pushViewController:firstVC animated:YES];
    
}


//设置分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    
//       BaseModel *model  = self.dataArr[indexPath.row];
//    BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollectionViewCell:model andCollectionView:collectionView andIndexPath:indexPath];
//        [cell setDataWithModel:model];
    
    RecommendListModel *model = self.dataArr[indexPath.row];
    RecommendListModelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    if (model.praised == true) {
        [cell.praiseBT setBackgroundImage:[UIImage imageNamed:@"yidianzan"] forState:UIControlStateNormal];
    }
    [cell setDataWithModel:model];
    [cell.commentBT addTarget:self action:@selector(commentUser:) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
    
    //测试
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor grayColor];
    
    
}

- (void)commentUser:(UIButton *)sender {
    
    UIView *v = [sender superview];//获取父类view
    RecommendListModelCell *cell = (RecommendListModelCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的
    RecommendListModel *model = self.dataArr[indexpath.row];
    ComentListViewController *comment = [[ComentListViewController alloc] init];
//    RecommendViewController *comment = [[RecommendViewController alloc] init];
    comment.feedId = model.ID;
     NSLog(@"%@", model.ID);
    comment.model = model;
    if (model.commentCount == 0) {
        if(self.keyView==nil){
            self.keyView=[[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        }
        //  设置键盘输入框
        self.keyView.delegate=self;
        [self.keyView.textView becomeFirstResponder];
        self.keyView.textView.returnKeyType = UIReturnKeySend;
        
        [self.view addSubview:self.keyView];
        
    }else {
    [_parent.navigationController pushViewController:comment animated:YES];
    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //测试跳转到详情页面
    
    RecommendListModel *model = _dataArr[indexPath.row];
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    
    recommendVC.feedId = model.ID;
   
    recommendVC.model = model;
    self.addview.addBtn.hidden = YES;
    [_parent.navigationController pushViewController:recommendVC animated:YES];

}




@end
