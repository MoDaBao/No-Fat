//
//  TrainTableViewController.m
//  NoFat
//
//  Created by lanou on 16/4/19.
//  Copyright © 2016年 lanou3g.com. All rights reserved.
//

#import "TrainTableViewController.h"
#import "ProgramModel.h"
#import "ProgramDailyListModel.h"
#import "FactoryTableViewCell.h"
#import "AddTrainViewController.h"
#import "DetailProgram2ViewController.h"
#import "DetailProgramViewController.h"
#import "ProgramModelCell.h"

#define UserViewBGColor [UIColor colorWithRed:58 / 255.0 green:60 / 255.0 blue:71 / 255.0 alpha:1.0]// 用户视图背景颜色

typedef void (^AddProgram)(NSMutableArray *IDArray, ProgramModel *programModel);
typedef void (^ChangeButton)();

//@protocol TrainTableViewControllerDelegate <NSObject>
//
//- (void)refreshView;
//
//@end

@interface TrainTableViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *trainTableView;
@property (nonatomic, strong) NSMutableArray *mineProgramsArray;//  我的计划
@property (nonatomic, strong) NSMutableArray *recommendProgramsArray;//  推荐计划
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, copy) AddProgram addProgramBlock;//  添加program
@property (nonatomic, strong) NSMutableArray *IDArray;//  保存本地数据库中的programID
@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, copy) ChangeButton changeButtonBlock;//  改变分区的button显示
//@property (nonatomic, assign) id<TrainTableViewControllerDelegate>delegate;

@end

@implementation TrainTableViewController

- (void)refreshView {
    NSLog(@"haha");
    [self.trainTableView reloadData];
}

//  lazyLoading
- (NSMutableArray *)mineProgramsArray {
    if (!_mineProgramsArray) {
        self.mineProgramsArray = [NSMutableArray array];
    }
    return _mineProgramsArray;
}

- (NSMutableArray *)recommendProgramsArray {
    if (!_recommendProgramsArray) {
        self.recommendProgramsArray = [NSMutableArray array];
    }
    return _recommendProgramsArray;
}

- (NSMutableArray *)IDArray {
    if (!_IDArray) {
        self.IDArray = [NSMutableArray array];
    }
    return _IDArray;
}

- (NSMutableArray *)viewsArray {
    if (!_viewsArray) {
        self.viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断用户是否登录
    NSString *userID = [[UserInfoManager shareInstance] getUserID];
    if (![userID isEqualToString:@" "]) {
        //登录状态 获取单例数据库对象
        UserTrainDB *db = [[UserTrainDB alloc] init];
        //获取数据表 没有就创建
        [db createDataTable];
        //查询数据是否存储，
        NSArray *array = [db selectDataWithUserID:userID];
        if (!array.count) {
            _sectionNum = 1;
            
        } else {
            _sectionNum = 2;
            _mineProgramsArray = array.mutableCopy;
            for (ProgramModel *model in array) {
                [self.IDArray addObject:model.programID];
            }
        }
        self.view.backgroundColor = [UIColor whiteColor];
        self.automaticallyAdjustsScrollViewInsets = NO;
            
        self.trainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 20 - 49) style:UITableViewStylePlain];
        self.trainTableView.delegate = self;
        self.trainTableView.dataSource = self;
        self.trainTableView.showsVerticalScrollIndicator = NO;
        // 注册cell
        [self.trainTableView registerNib:[UINib nibWithNibName:@"ProgramModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProgramModel class])];
        [self.view addSubview:_trainTableView];
        
        for (int i = 0; i < 2; i ++) {
            UIView *sv = [self createView];
            [self.viewsArray addObject:sv];
        }
        
        // block实现体
        __weak TrainTableViewController *weakSelf = self;
        self.addProgramBlock = ^(NSMutableArray *IDArray, ProgramModel *program) {
            for (NSString *ID in IDArray) {
                if ([ID isEqualToString:program.programID]) {
//                    [weakSelf.mineProgramsArray addObject:program];
                } else {
                    if (weakSelf.recommendProgramsArray.count < 5) {
                        [weakSelf.recommendProgramsArray addObject:program];
                    }
                }
            }
        };

        //  请求数据
        [self requestProgramData];
        
    } else {
        //未登录状态 模态弹出登录页面
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegist" bundle:nil];
        //        UINavigationController *naVC = [storyboard instantiateInitialViewController];
        //        [self presentViewController:naVC animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
}

- (UIView *)createView {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *textLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 100, 30)];// 分区标题
    textLable.tag = 101;
    [sectionView addSubview:textLable];
    
    UIButton *addBt = [UIButton buttonWithType:UIButtonTypeCustom];// 添加按钮
    addBt.frame = CGRectMake(kScreenWidth - 20 - 30, 7, 30, 30);
    [addBt setBackgroundImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
    __weak TrainTableViewController *weakSelf = self;
    addBt.block = ^{
        AddTrainViewController *addVC = [[AddTrainViewController alloc] init];
        // 隐藏tabbar
        self.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:addVC animated:YES];
    };
    addBt.tag = 102;
    [sectionView addSubview:addBt];
    
    return sectionView;
}

//  请求数据
- (void)requestProgramData {
    // 网络请求
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:PROGRAMSLIST_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        // 获取训练计划数据源
        for (NSDictionary *programDic in responseObject[@"programs"]) {
            NSMutableArray *dailyArray = [NSMutableArray array];
            // 获取训练详细数据源
            for (NSDictionary *dailyListDic in programDic[@"programDailyList"]) {
                ProgramDailyListModel *dailyList = [[ProgramDailyListModel alloc] init];
                [dailyList setValuesForKeysWithDictionary:dailyListDic];
                [dailyArray addObject:dailyList];
            }
            //            NSLog(@"ZZZZZZZZ%@",dailyArray);
            ProgramModel *program = [[ProgramModel alloc] init];
            [program setValuesForKeysWithDictionary:programDic];
            program.programDailyList = dailyArray;
            
            if (_IDArray.count > 0) {
                if (self.addProgramBlock) {// 安全保护 确保block执行前有实现体
                    self.addProgramBlock(_IDArray, program);
                }
            } else {
                if (_recommendProgramsArray.count < 5) {
                    [_recommendProgramsArray addObject:program];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.trainTableView reloadData];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error is %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

//  偏移量改变时改变分区中addBt的显示
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_sectionNum == 2) {
    
        CGFloat offsetY = kScreenHeight / 2.5 * _mineProgramsArray.count + 44;
        if (scrollView.contentOffset.y > offsetY) {

            UIView *view1 = self.viewsArray[0];
            UIButton *bt1 = [view1 viewWithTag:102];
            bt1.hidden = YES;
            
            UIView *view2 = self.viewsArray[1];
            UIButton *bt2 = [view2 viewWithTag:102];
            bt2.hidden = NO;
        } else if (scrollView.contentOffset.y < offsetY) {
            UIView *view1 = self.viewsArray[0];
            UIButton *bt1 = [view1 viewWithTag:102];
            bt1.hidden = NO;
            
            UIView *view2 = self.viewsArray[1];
            UIButton *bt2 = [view2 viewWithTag:102];
            bt2.hidden = YES;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sectionNum == 2) {
        switch (section) {
            case 0:
                return self.mineProgramsArray.count;
                break;
                
            default:
                return self.recommendProgramsArray.count;
                break;
        }
    } else {
        return self.recommendProgramsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseModel *model = nil;
    if (_sectionNum == 2) {
        switch (indexPath.section) {
            case 0:
                model = self.mineProgramsArray[indexPath.row];
                break;
                
            default:
                model = self.recommendProgramsArray[indexPath.row];
                break;
        }
    } else {
        model = self.recommendProgramsArray[indexPath.row];
    }
    
    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model andTableView:tableView andIndexPath:indexPath];
//    ProgramModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pp" forIndexPath:indexPath];
    [cell setDataWithModel:model];
    
    return cell;
}

//  返回分区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (_sectionNum == 2) {
        switch (section) {
            case 0: {
                UIView *view1 = _viewsArray[0];
                UILabel *label1 = [view1 viewWithTag:101];
                label1.text = @"我的训练";
                UIButton *bt1 = [view1 viewWithTag:102];
                bt1.hidden = NO;
                return view1;
            }
            break;
                
            default: {
                UIView *view2 = _viewsArray[1];
                UILabel *label2 = [view2 viewWithTag:101];
                label2.text = @"推荐训练";
                UIButton *bt2 = [view2 viewWithTag:102];
                bt2.hidden = YES;
                return view2;
            }
            break;
        }
    } else {
        UIView *view = _viewsArray[0];
        UILabel *label = [view viewWithTag:101];
        label.text = @"推荐训练";
        UIButton *bt = [view viewWithTag:102];
        bt.hidden = NO;
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight / 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

//  点击cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(referenceView)]) {
//        [self.delegate refreshView];
//    }
    // push后隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    if (_sectionNum == 2) {
        switch (indexPath.section) {
            case 0: {
                DetailProgram2ViewController *detailVC = [[DetailProgram2ViewController alloc] init];
//                self.delegate = detailVC;
//                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.trainVC = self;
                detailVC.program = _mineProgramsArray[indexPath.row];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            break;
            default: {
                DetailProgramViewController *detailVC = [[DetailProgramViewController alloc] init];
//                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.trainVC = self;
                detailVC.program = _recommendProgramsArray[indexPath.row];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            break;
        }
    } else {
        DetailProgramViewController *detailVC = [[DetailProgramViewController alloc] init];
//        detailVC.hidesBottomBarWhenPushed = YES;
//        self.delegate = detailVC;
        detailVC.trainVC = self;
        detailVC.program = _recommendProgramsArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
