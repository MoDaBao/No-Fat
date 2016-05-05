//
//  SearchViewController.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/25.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "SearchViewController.h"
#import "AddTimeListModel.h"
#import "AddTimeListModelCell.h"
#import "AddTimeNoImageModelCell.h"
#import "AddTimeDetailViewController.h"
#import "SearchButtonView.h"
#import "UIButton+FiniishClick.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>



@property (nonatomic, retain)UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) CGFloat(^cellHeightBlock)();//block cell的高度

@property (nonatomic, strong) SearchButtonView *searchButtonView;
@property (nonatomic, strong) UIButton *searchBT;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSNumber *start;


@end

@implementation SearchViewController

//push过来隐藏tabbar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}


- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _searchArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _searchButtonView  = [[[NSBundle mainBundle] loadNibNamed:@"SearchButtonView" owner:nil options:nil] lastObject];
    _searchButtonView.frame = CGRectMake(0, 61, ScreenWidth, ScreenHeight);
    
    _searchButtonView.majiaxianBT.block = ^{
        [self click:_searchButtonView.majiaxianBT];
    };
    
    _searchButtonView.shoutuiBT.block = ^{
        [self click:_searchButtonView.shoutuiBT];
    };
    
    _searchButtonView.jianfeiBT.block = ^{
        [self click:_searchButtonView.jianfeiBT];
    };
    
    _searchButtonView.yujiaBT.block = ^{
        [self click:_searchButtonView.yujiaBT];
    };
    _searchButtonView.xiaotuiBT.block = ^{
        [self click:_searchButtonView.xiaotuiBT];
    };
    _searchButtonView.fujiBT.block = ^{
        [self click:_searchButtonView.fujiBT];
    };
    
    _searchButtonView.yinshiBT.block = ^{
        [self click:_searchButtonView.yinshiBT];
    };
    
    _searchButtonView.zengjiBT.block = ^{
        [self click:_searchButtonView.zengjiBT];
    };
    
    [self.view addSubview:_searchButtonView];
    
    
    //点击view空白处的回收键盘的手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide1:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self cresteSearchBarView];

    // Do any additional setup after loading the view from its nib.
}

- (void)click:(UIButton *)sender {

    //获取button上的文字
    self.mySecarBar.text = [sender titleForState:UIControlStateNormal];
    [self requestData:self.mySecarBar.text];
    [self createTableView];

    NSLog(@"%@", self.mySecarBar.text);
    
}

//点击空白处回收键盘的方法
-(void)keyboardHide1:(UITapGestureRecognizer*)tap1{
    [self.mySecarBar resignFirstResponder];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 61, ScreenWidth, ScreenHeight - 61) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddTimeListModelCell" bundle:nil] forCellReuseIdentifier:@"AddTimeListModelCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AddTimeNoImageModelCell" bundle:nil] forCellReuseIdentifier:@"AddTimeNoImageModelCell"];
    
    [self.view addSubview:_tableView];
    
}


- (void)requestData:(NSString *)str {
      NSLog(@"%@", str);
    NSString *key = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
    NSLog(@"%@", key);
    
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftsns/refreshUserFeed?&key=%@",key] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"dic%@", dic);
    
        //搜索先清空
        [self.searchArray removeAllObjects];
        
        NSArray *arr = dic[@"feeds"];
        for (NSDictionary *dataDic in arr) {
            AddTimeListModel *model = [[AddTimeListModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            
            NSString *searchString = [self.mySecarBar text];
            NSLog(@"%@",model.content);
            

            BOOL status =  [model.content containsString:searchString];
            if (status) {
                [self.searchArray addObject:model];
            }
            NSLog(@"%@", self.searchArray);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self createTableView];
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}

/*- (void)createSearchViewController {
    //searchResultsController参数设置为nil,能在相同的视图中显示搜索结果
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchBar.frame = CGRectMake(0, 20, 375, 40);
    
    //设置代理 搜索数据更新
    self.searchController.searchResultsUpdater = self;
    
    //遮盖层
    //    self.searchController.dimsBackgroundDuringPresentation = YES;
    
    //当点击输入框的时候导航视图控制器的显隐问题
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    UIView *searchTextField = [[[self.mySecarBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];
    
    
    //弹出键盘的样式
    self.searchController.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    //输入框的占位符
    self.searchController.searchBar.placeholder = @"搜索FitTimer或者动态";
    
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:0.3];
    
    
    //    self.searchController.searchBar.tintColor = [UIColor redColor];
    
    //按钮
    //    self.searchController.searchBar.showsBookmarkButton = YES;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    

}*/

- (void)cresteSearchBarView{
    
    _mySecarBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 41)];
    _mySecarBar.delegate = self;
    
    NSLog(@"%@", _mySecarBar.subviews);
    
    //改变颜色
    
//    SecarBar的背景颜色
    self.mySecarBar.barTintColor = [UIColor whiteColor];
    
    
    //输入框的背景颜色
    UIView *searchTextField = [[[self.mySecarBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1.0];

    //控件的样式
    _mySecarBar.barStyle = UIBarStyleDefault;
    
    //点击SecarBar弹出键盘的样式
    _mySecarBar.keyboardType = UIKeyboardTypeDefault;
    
    //输入框的占位符
    _mySecarBar.placeholder = @"搜索FitTimer或者动态";
    
    
//    _mySecarBar.showsCancelButton = YES;

    
    //指定的控件是否会有透视效果
    _mySecarBar.translucent = NO;
    
    //设置搜索框中文本框文本的偏移量
    [_mySecarBar setSearchTextPositionAdjustment:UIOffsetMake(0, 0)];
    
    [self.view addSubview:self.mySecarBar];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    _searchBT = [[UIButton alloc] init];
    UIView *topView = self.mySecarBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            _searchBT = (UIButton*)subView;
        }
    }
    if (_searchBT) {
        [_searchBT setTitle:@"搜索" forState:UIControlStateNormal];
   
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[SearchButtonView class]]) {
            SearchButtonView *buttonView = (SearchButtonView *)view;
            [buttonView removeFromSuperview];
            break;
        }
    }
    
    for (UITableView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            [view removeFromSuperview];
        }
    }
     [self createTableView];
     [self requestData:_mySecarBar.text];
 
    
//    NSLog(@"%@", _mySecarBar.text);
//    [self.tableView reloadData];

}


//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
//    searchText = self.mySecarBar.text;
//    [self requestData];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
      AddTimeListModel *model = self.searchArray[indexPath.row];
        
    if (model.image.length > 0) {
        AddTimeListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTimeListModelCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddTimeListModelCell" owner:nil   options:nil].lastObject;
        }
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
                
                cell.nameLabel.text = model.username;
                
            });
        } error:^(NSError *error) {
            
        }];
        
        [cell setDataWithModel:model];
        self.cellHeightBlock = ^{
            return cell.cellHeight;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        AddTimeNoImageModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTimeNoImageModelCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"AddTimeNoImageModelCell" owner:nil   options:nil].lastObject;
        }
        [cell setDataWithModel:model];
        self.cellHeightBlock = ^{
            return cell.cellHeight;
        };
    
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellHeightBlock) {
        return self.cellHeightBlock();
    }else {
        return 0.f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddTimeListModel *model = self.searchArray[indexPath.row];
    AddTimeDetailViewController *addTimeVC = [[AddTimeDetailViewController alloc] init];
    
    addTimeVC.feedId = model.ID;
    addTimeVC.model = model;
    [self.navigationController pushViewController:addTimeVC animated:YES];
    
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
