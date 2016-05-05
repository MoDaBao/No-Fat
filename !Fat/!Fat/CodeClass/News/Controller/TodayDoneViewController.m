//
//  TodayDoneViewController.m
//  No!Fat 666
//
//  Created by 莫大宝 on 16/4/27.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "TodayDoneViewController.h"
#import "TodayDoneCell.h"
#import "TodayDoneDB.h"
#import "AddTrainDescViewController.h"

@interface TodayDoneViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TodayDoneViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        TodayDoneDB *db = [[TodayDoneDB alloc] init];
        [db createTable];
        NSArray *array = [db selectAllData];
        self.dataArray = [NSMutableArray array];
        for (TodayDoneModel *model in array) {
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;// 设置最小的行间木
    layout.minimumInteritemSpacing = 5;// 设置item与item之间的间距
    CGFloat itemWidth = (kScreenWidth - 10) / 3;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);// 设置每一个item的尺寸大小
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;// 设置集合视图的滑动方向
//    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 1);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[TodayDoneCell class] forCellWithReuseIdentifier:@"reuse"];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日完成的训练";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createCollectionView];
    
    // Do any additional setup after loading the view.
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    TodayDoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {// 在数组范围内显示文字内容
        TodayDoneModel *model = self.dataArray[indexPath.row];
        cell.trainItem.text = model.desc;
    } else {// 在数组范围外显示添加按钮
        CGFloat imageViewWidth = cell.frame.size.width * 0.4;
        CGFloat imageViewHeight = imageViewWidth;
        CGFloat imageViewX = cell.frame.size.width * 0.5 - imageViewWidth * 0.5;
        CGFloat imageVeiwY = cell.frame.size.height * 0.5 - imageViewHeight * 0.5;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageVeiwY, imageViewWidth, imageViewHeight)];
        imageView.image = [UIImage imageNamed:@"addItem"];
        [cell addSubview:imageView];
        
    }
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {// 点击了在数组范围内的单元格
        AddTrainDescViewController *descVC = [[AddTrainDescViewController alloc] init];
        TodayDoneModel *model = self.dataArray[indexPath.row];
        descVC.trainName = model.desc;
        [self.navigationController pushViewController:descVC animated:YES];
    } else {// 点击了添加按钮单元格
        AddTrainDescViewController *descVC = [[AddTrainDescViewController alloc] init];
        [self.navigationController pushViewController:descVC animated:YES];
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
