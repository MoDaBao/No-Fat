//
//  AddPersonViewController.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/22.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AddPersonViewController.h"
#import "AddPersonModel.h"
#import "AddPersonModelCell.h"
#import "MyCollectionReusableView.h"

@interface AddPersonViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)  NSArray *titleArr;


@property (nonatomic, strong) NSMutableArray *oneArr;
@property (nonatomic, strong) NSMutableArray *twoArr;

@property (nonatomic, strong) NSMutableArray *threeArr;
@property (nonatomic, strong) NSMutableArray *fourArr;



@end

@implementation AddPersonViewController

//push过来隐藏tabbar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;  
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr =[[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)oneArr {
    if (!_oneArr) {
        _oneArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _oneArr;
}

- (NSMutableArray *)twoArr {
    if (!_twoArr) {
        _twoArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _twoArr;
}

- (NSMutableArray *)threeArr {
    if (!_threeArr) {
        _threeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _threeArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加关注";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;

    [self requsetData];
    
    _titleArr = @[ @"健身达人", @"热推红人"];
   
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //item之间的最小间距
    layout.minimumInteritemSpacing = 2;
    //行之间的饿最小间距
    layout.minimumLineSpacing = 2;
    //item的大小
    layout.itemSize = CGSizeMake(ScreenWidth / 2 - 15, ScreenWidth / 2 + 30);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) collectionViewLayout:layout];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //增广视图的大小
    CGFloat totalWidth = self.view.frame.size.width;
    layout.headerReferenceSize = CGSizeMake(totalWidth, 30);
    
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"AddPersonModelCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([AddPersonModel class])];

    
    [_collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //集合视图如果想要分区头视图显示。必须注册增广视图
    [_collectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:_collectionView];

}

- (void)requsetData {
    
    [NetWorkRequestManager requestWithType:GET url:TIAJIAGUANZHU dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
        NSArray *arr = dic[@"recommendUsers"];
        for (NSDictionary *headDic in arr) {
            AddPersonModel *model = [[AddPersonModel alloc] init];
            [model setValuesForKeysWithDictionary:headDic];
            if ([model.type isEqualToNumber:@(1)]) {
//                 AddPersonModel *model = [[AddPersonModel alloc] init];
                
                [self.oneArr addObject:model];
            }else if ([model.type isEqualToNumber:@(2)]) {
//                 AddPersonModel *model = [[AddPersonModel alloc] init];
//                [model setValuesForKeysWithDictionary:headDic];
                [self.twoArr addObject:model];
            }else if ([model.type isEqualToNumber:@(3)]) {
//                 AddPersonModel *model = [[AddPersonModel alloc] init];
//                [model setValuesForKeysWithDictionary:headDic];
                [self.threeArr addObject:model];
            }
        }
          NSLog(@"oneArr%@", self.oneArr);
          NSLog(@"two%@", self.twoArr);
          NSLog(@"threeArr%@", self.threeArr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createCollectionView];
            [self.collectionView reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}

#pragma mark ------代理方法------


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddPersonModel *model  = nil;

    if (indexPath.section == 0) {
        model = _twoArr[indexPath.row];
    }else if (indexPath.section == 1) {
        model = _threeArr[indexPath.row];
    }
//        else if (indexPath.section == 2) {
//        model = _threeArr[indexPath.row];
//    }
    BaseCollectionViewCell *cell = nil;
    
    cell = [FactoryCollectionViewCell createCollectionViewCell:model andCollectionView:collectionView andIndexPath:indexPath];
    
    [cell setDataWithModel:model];
 
    
//    if ([model.type isEqualToNumber:@(indexPath.section)]) {
//        NSLog(@"%@", model.type);
//        model = self.oneArr[indexPath.row];
//    }else if ([model.type.stringValue isEqualToString:@"2"]) {
//        model = self.twoArr[indexPath.row];
//    }else if ([model.type.stringValue isEqualToString:@"3"]) {
//        model = self.threeArr[indexPath.row];
//    }else {
//        model = self.dataArr[indexPath.row];
//    }
   //    if ([model.type isEqualToNumber:@(indexPath.section)]) {
//         cell = [FactoryCollectionViewCell createCollectionCellWithModel:model andCollectionView:collectionView andIndexPath:indexPath];
//        [cell setDataWithModel:model];
//    }
    return cell;
}

//设置分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

//返回增广视图  也就是集合视图的头视图或者尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//    view.backgroundColor = [UIColor lightGrayColor];
    view.headerLabel.text  =  _titleArr[indexPath.section];
    return view;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //测试跳转到详情页面
    
//    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
//    [_parent.navigationController pushViewController:recommendVC animated:YES];
    
}


//返回按钮的方法
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
