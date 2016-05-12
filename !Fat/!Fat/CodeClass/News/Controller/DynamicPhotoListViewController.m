//
//  DynamicPhotoListViewController.m
//  !Fat
//
//  Created by hu胡洁佩 on 16/5/6.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "DynamicPhotoListViewController.h"
#import "DynamicPhotoListViewCell.h"

@interface DynamicPhotoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataListArr;

@end

@implementation DynamicPhotoListViewController


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏的的返回按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self requestData];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataListArr {
    if (!_dataListArr) {
        _dataListArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataListArr;
}

- (void)createcollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //item之间的最小间距
    layout.minimumInteritemSpacing = 2;
    //行之间的饿最小间距
    layout.minimumLineSpacing = 2;
    //item的大小
    layout.itemSize = CGSizeMake(ScreenWidth / 3 - 15, ScreenWidth / 3);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight- 64) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"DynamicPhotoListViewCell" bundle:nil] forCellWithReuseIdentifier:@"reuse"];

    
    
    [self.view addSubview:_collectionView];
    
    //上拉刷新
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDataMore)];
//    
//    //下拉刷新
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
}


//  请求动态的cell的数据
- (void)requestData {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshUserFeed?user_id=%@", _userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject%@", responseObject);
        
        NSArray *arr = responseObject[@"feeds"];
        for (NSDictionary *dic in arr) {
            RecommendListModel *model = [[RecommendListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataListArr addObject:model];
        }
//        NSLog(@"%@", self.dataListArr);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //            [self.tableView reloadData];
            [self createcollectionView];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


//设置分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataListArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendListModel *model = self.dataListArr[indexPath.row];
    DynamicPhotoListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [cell setDataWithModel:model];
    return cell;
    
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
