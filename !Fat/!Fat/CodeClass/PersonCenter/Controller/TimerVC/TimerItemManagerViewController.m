//
//  TimerItemManagerViewController.m
//  Timer
//
//  Created by 莫大宝 on 16/4/25.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "TimerItemManagerViewController.h"
#import "TimerDetailItemOtherCell.h"
#import "TimerDetailItemStepCell.h"
#import "AlterTitleViewController.h"
#import "CustomPickerView.h"
#import "MOCustomDatePickerView.h"
#import "StepDetailViewController.h"
#import "ManagerView.h"
#import "StartView.h"

@interface TimerItemManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *itemArray;
//@property (nonatomic, strong) NSMutableArray *stepArray;
@property (nonatomic, strong) TimerDetailItemModel *orginModel;// 如果是新建显示默认原始数据
//@property (nonatomic, strong) TimerDetailItemModel *selectModel;// 数据库中某一项
@property (nonatomic, strong) TimerDetailItemModel *oldModel;

@property (nonatomic, strong) ManagerView *managerView;

@property (nonatomic, strong) UIBarButtonItem *saveItem;

@property (nonatomic, strong) UIBarButtonItem *managerItem;

@property (nonatomic, assign) BOOL isManager;// 是否是管理按钮

@property (nonatomic, strong) StartView *startView;


@end

@implementation TimerItemManagerViewController


#pragma mark -----lazyload-----

- (TimerDetailItemModel *)selectModel {
    if (!_selectModel) {
        TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
        [db createTable];
        _selectModel = [db selectDataWithTitle:self.headTitle];
//        NSString *documentPatn = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSLog(@"%@",documentPatn);
    }
    return _selectModel;
}

- (TimerDetailItemModel *)orginModel {
    if (!_orginModel) {
        self.orginModel = [[TimerDetailItemModel alloc] init];
        _orginModel.title = @"新计时器";
        _orginModel.titlecolor = @"kBlue";
        _orginModel.titleicon = @"runWhite";
        _orginModel.step = @"kPink&新建步骤&00:20/kBlue&新建步骤&00:20";
        _orginModel.countdown = @15;
        _orginModel.loopcount = @1;
    }
    return _orginModel;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
        [db createTable];
        if (_isNew) {
            self.itemArray = [NSMutableArray array];
            self.itemArray = [[self.orginModel.step componentsSeparatedByString:@"/"] mutableCopy];
        } else {
//            TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
//            [db createTable];
//            self.selectModel = [db selectDataWithTitle:self.title];
            self.itemArray = [NSMutableArray array];
            self.itemArray = [[self.selectModel.step componentsSeparatedByString:@"/"] mutableCopy];
            
        }
    }
    return _itemArray;
}


#pragma mark -----加载视图-----

- (void)createTableView {
//    if (_isNew) {
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    } else {
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)createButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    // 保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 40, 20);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    // 管理按钮
    UIButton *managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    managerBtn.frame = CGRectMake(0, 0, 40, 20);
    [managerBtn setTitle:@"管理" forState:UIControlStateNormal];
    [managerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    managerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [managerBtn addTarget:self action:@selector(manager) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回baritem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    // 保存baritem
    self.saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    // 管理baritem
    self.managerItem = [[UIBarButtonItem alloc] initWithCustomView:managerBtn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    imageView.layer.cornerRadius = 5;
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 30)];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    if (_isNew) {
        imageView.image = [UIImage imageNamed:self.orginModel.titleicon];
        label.text = self.orginModel.title;
        [ChangeColorManager changColorWithImageView:imageView color:self.orginModel.titlecolor];
        self.navigationItem.rightBarButtonItem = self.saveItem;
        self.isManager = NO;
    } else {
        imageView.image = [UIImage imageNamed:self.selectModel.titleicon];
        label.text = self.selectModel.title;
        [ChangeColorManager changColorWithImageView:imageView color:self.selectModel.titlecolor];
        self.navigationItem.rightBarButtonItem = self.managerItem;
        self.isManager = YES;
    }
    label.width = [UILabel getWidthWithTitle:label.text font:label.font];
    view.width = label.width + imageView.width;
    
    self.navigationItem.titleView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0];
    [self createButton];
    [self createTableView];
    
    if (_isNew) {
        self.managerView = [[[NSBundle mainBundle] loadNibNamed:@"ManagerView" owner:nil options:nil] lastObject];
        self.managerView.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, 40);
        [self.view addSubview:self.managerView];
        self.tableView.y = kNavigationHeight + self.managerView.height;
        self.tableView.height = self.tableView.height - self.managerView.height;
    }
    
    if (_isManager) {
        [self createStartView];
    }
    
}

- (void)createStartView {
    self.startView = [[[NSBundle mainBundle] loadNibNamed:@"StartView" owner:nil options:nil] lastObject];
    CGFloat height = 80 / 667.0 * kScreenHeight;
    self.startView.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
    [self.view addSubview:self.startView];
}


#pragma mark -----按钮方法-----

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save {
    NSLog(@"save");
    TimerDetailItemDB *db = [[TimerDetailItemDB alloc] init];
    if (_isNew) {
        [db insertTimerDetailItemModel:self.orginModel];
        [self.navigationController popViewControllerAnimated:YES];
     } else {
//         if (self.oldModel) {
        [db updateWithTitle:self.oldModel.title model:self.selectModel];
//             NSLog(@"更新");
//         } else {
//             [db updateWithTitle:self.selectModel.title model:self.selectModel];
         //         }
         self.tableView.height += self.managerView.height;
         [UIView animateWithDuration:.2 animations:^{
             self.managerView.y = 0;
             self.tableView.y -= self.managerView.height;
         }];
         [self.managerView removeFromSuperview];
         self.managerView = nil;
         self.navigationItem.rightBarButtonItem = self.managerItem;
         self.isManager = YES;
         [self.tableView reloadData];
         
     }
    
    
}

- (void)manager {
    self.managerView = [[[NSBundle mainBundle] loadNibNamed:@"ManagerView" owner:nil options:nil] lastObject];
    self.managerView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [self.view addSubview:self.managerView];
    self.tableView.height = self.tableView.height - self.managerView.height;
    
    [UIView animateWithDuration:.2 animations:^{
        self.managerView.y = kNavigationHeight;
        self.tableView.y += self.managerView.height;
        
    }];
    self.navigationItem.rightBarButtonItem = self.saveItem;
    self.isManager = NO;
    [self.tableView reloadData];
}

#pragma mark -----表视图代理-----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuse";
    if (indexPath.row > 1 && indexPath.row < self.itemArray.count + 2) {// 步骤
        TimerDetailItemStepCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimerDetailItemStepCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.layer.cornerRadius = 10;
            [cell.contentView removeFromSuperview];
            
        }
        NSString *string = self.itemArray[indexPath.row - 2];// 获取步骤字符串
        NSArray *array = [string componentsSeparatedByString:@"&"];// 通过&符号分割字符串
//        [self assignmentWithImageView:cell.icon color:[array firstObject]];// 设置步骤颜色
        [ChangeColorManager changColorWithImageView:cell.icon color:[array firstObject]];// 设置步骤颜色
        cell.stepName.text = array[1];// 设置步骤名称
        cell.time.text = [array lastObject];
        cell.click = ^ {
            StepDetailViewController *stepVC = [[StepDetailViewController alloc] init];
            stepVC.backBlock = ^ (NSString *step) {
                self.itemArray[indexPath.row - 2] = step;
                if (_isNew) {
                    self.orginModel.step = step;
                    self.itemArray[indexPath.row] = step;
                    [self.tableView reloadData];
                } else {
                    self.selectModel.step = step;
                    [self.tableView reloadData];
                }
            };
            stepVC.step = string;
            [self.navigationController pushViewController:stepVC animated:YES];
            
        };
        if (_isManager) {
            CGRect newframe = cell.time.frame;
            newframe.origin.x = kScreenWidth - (cell.time.frame.size.width + 10);
//            cell.time.x = kScreenWidth - (cell.time.width + 10);
            cell.time.frame = newframe;
            cell.alterBtn.hidden = YES;
        } else {
//            cell.time.x = kScreenWidth - (cell.time.width + 20 + cell.alterBtn.width);
            CGRect newframe = cell.time.frame;
            newframe.origin.x = kScreenWidth - (cell.time.frame.size.width + 20 + cell.alterBtn.frame.size.width);
            cell.time.frame = newframe;
            cell.alterBtn.hidden = NO;
        }
        
        return cell;
        
    } else {// 标题、倒计时、几轮
        TimerDetailItemOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TimerDetailItemOtherCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.icon.layer.cornerRadius = 10;
        }
        if (_isNew) {
            [cell setDataWithModel:self.orginModel indexPath:indexPath];
            
        } else {
            [cell setDataWithModel:self.selectModel indexPath:indexPath];
        }
        return cell;
    }
    
    
}

// 给颜色赋值
//- (void)assignmentWithImageView:(UIImageView *)imageView color:(NSString *)color {
//    if ([color isEqualToString:@"kPink"]) {
//        imageView.backgroundColor = kPink;
//    } else if ([color isEqualToString:@"kGray"]) {
//        imageView.backgroundColor = kGray;
//    } else if ([color isEqualToString:@"kGreen"]) {
//        imageView.backgroundColor = kGreen;
//    } else if ([color isEqualToString:@"kBlue"]) {
//        imageView.backgroundColor = kBlue;
//    }
//
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isManager) {
        return NO;
    }
    if (indexPath.row > 1 && indexPath.row < self.itemArray.count + 2) {
        return YES;
    } else {
        return NO;
    }
}

//  左滑进入编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 表视图开始更新
    [tableView beginUpdates];
    // 删除单元格
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    // 删除数组中与该单元格绑定的数据,此步骤应该在最后一步做
    [self.itemArray removeObjectAtIndex:indexPath.row - 2];
    NSString *string = [self.itemArray componentsJoinedByString:@"/"];
    // 修改模型的值
    if (_isNew) {
        self.orginModel.step = string;
    } else {
        self.selectModel.step = string;
    }
    
    // 表视图结束更新
    [tableView endUpdates];
}

//  修改左滑出现的delete按钮的文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isManager) {
        if (indexPath.row == 0) {
            AlterTitleViewController *alterTitleVC = [[AlterTitleViewController alloc] init];
            if (_isNew) {
                alterTitleVC.detailItemModel = self.orginModel;
                alterTitleVC.passValue = ^(NSString *title) {
                    self.orginModel.title = title;
                    [self.tableView reloadData];
                };
            } else {
                alterTitleVC.detailItemModel = self.selectModel;
                alterTitleVC.passValue = ^(NSString *title) {
                    if (!self.oldModel) {
                        self.oldModel = [[TimerDetailItemModel alloc] init];
                    }
                    self.oldModel.title = self.selectModel.title;
                    self.selectModel.title = title;
                    [self.tableView reloadData];
                };
            }
            [self.navigationController pushViewController:alterTitleVC animated:YES];
            
        } else if (indexPath.row == self.itemArray.count + 2) {
            NSMutableArray *mArr = [NSMutableArray array];
            for (int i = 1; i < 100; i ++) {
                [mArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            CustomPickerView *customView = [CustomPickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:@"" dataArray:mArr];
            customView.click = ^(NSString *item) {
                NSLog(@"%@",item);
                if (_isNew) {
                    self.orginModel.loopcount = [NSNumber numberWithInt:[item intValue]];
                    [self.tableView reloadData];
                } else {
                    self.selectModel.loopcount = [NSNumber numberWithInt:[item intValue]];
                    [self.tableView reloadData];
                }
            };
            [self.view addSubview:customView];
        } else if (indexPath.row == 1) {
            MOCustomDatePickerView *customView = [MOCustomDatePickerView cretaCustomPickerViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) title:nil dataArray:nil];
            customView.click = ^ (NSString *item) {
                if (_isNew) {
                    self.orginModel.countdown = [NSNumber numberWithInt:[item intValue]];
                    [self.tableView reloadData];
                } else {
                    self.selectModel.countdown = [NSNumber numberWithInt:[item intValue]];
                    [self.tableView reloadData];
                }
            };
            [self.view addSubview:customView];
        }
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
