//
//  AttentionView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "AttentionView.h"
#import "AttentionDetailViewController.h"
#import "AttentionListModel.h"
#import "AttentionListModelCell.h"
#import "AttentionListHeaderView.h"
#import "AddPersonViewController.h"


@interface AttentionView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) CGFloat (^CellHeightBlock)();//cell 的高度
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) AttentionListHeaderView *attentionListHeaderView;//头视图
@property (nonatomic, strong)MyActivityIndicatorView *myActivityIndicatorView;

@end

@implementation AttentionView

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataList;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 自带菊花方法
        self.myActivityIndicatorView = [[MyActivityIndicatorView alloc]init];
        [self addSubview:_myActivityIndicatorView];
        // 动画开始
        [_myActivityIndicatorView startAnimating];
        //        NSLog(@"%@", self.dataArr);
        [self requestData];
        
    }
    return self;
}

- (void)requestData {
    [NetWorkRequestManager requestWithType:GET url:GUANZHULIST_URL dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
//        NSLog(@"dic%@", dic);
        NSArray *arr = dic[@"feeds"];
        for (NSDictionary *dataDic in arr) {
            AttentionListModel *model = [[AttentionListModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataList addObject:model];
        }

//        NSLog(@"datalist%@",arr );
        dispatch_async(dispatch_get_main_queue(), ^{
             [self createTableView];
             [self.tableView reloadData];
            // 动画结束
            [_myActivityIndicatorView stopAnimating];
        });
        
    } error:^(NSError *error) {
        
        NSLog(@"error%@", error);
        
    }];
}



- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.frame.size.width , self.frame.size.height ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 1000;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AttentionListModelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ppp"];
   
    //加载xib
     _attentionListHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"AttentionListHeaderView" owner:nil options:nil] lastObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.attentionListHeaderView addGestureRecognizer:tap];
    
    self.tableView.tableHeaderView = _attentionListHeaderView;
    [self addSubview:_tableView];
    
}

//轻拍手势方法
- (void)tap:(UIGestureRecognizer *)tap {
    
    AddPersonViewController *addP = [[AddPersonViewController alloc] init];
    
    [_parent.navigationController pushViewController:addP animated:YES];
    
}

#pragma mark -------tableViewDelegate-------

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10; // you can have your own choice, of course
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttentionListModel *model = self.dataList[indexPath.row];
//    BaseTableViewCell *cell = [FactoryTableViewCell createTableViewCell:model withTableView:tableView indexPath:indexPath];
//    [cell setDataWithModel:model];
    
    AttentionListModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ppp" forIndexPath:indexPath];
    [cell setDataWithModel:model];
    cell.selectionStyle = NO;
    
    [NetWorkRequestManager requestWithType:GET url:[NSString stringWithFormat:@"http://api.fit-time.cn/ftuser/getUserByIds?id=%@",model.userId] dic:@{} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@", dic);
        NSArray *arr = dic[@"users"];
        NSDictionary *headDic = [arr lastObject];
        UserModel *model = [[UserModel alloc] init];
        [model setValuesForKeysWithDictionary:headDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([model.avatar hasPrefix:@"http"]) {
                [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            }else {
                
                NSArray *arr = [model.avatar componentsSeparatedByString:@"/"];
                NSString *imageName = [arr lastObject];
                NSString *image = [NSString stringWithFormat:@"http://ft-user.fit-time.cn/%@@!small", imageName];
                [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:image]];
            }
            
            cell.userName.text = model.username;
            
        });
    } error:^(NSError *error) {
        
    }];

    
    self.CellHeightBlock = ^{
        return cell.cellHeight;
        
    };
    
    [cell.commentBT addTarget:self action:@selector(commentUser:) forControlEvents:UIControlEventTouchUpInside];

    //测试
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

//评论按钮的方法
- (void)commentUser:(UIButton *)sender {
    
    UIView *v = [sender superview];//获取父类view
   AttentionListModelCell *cell = (AttentionListModelCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];//获取cell对应的
    RecommendListModel *model = self.dataList[indexpath.row];
    ComentListViewController *comment = [[ComentListViewController alloc] init];
    //    RecommendViewController *comment = [[RecommendViewController alloc] init];
    comment.feedId = model.ID;
    NSLog(@"%@", model.ID);
    comment.model = model;
    [_parent.navigationController pushViewController:comment animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AttentionListModel *model = self.dataList[indexPath.row];
    AttentionDetailViewController *attentionVC = [[AttentionDetailViewController alloc] init];
    attentionVC.feedId = model.ID;
    attentionVC.model = model;
    [_parent.navigationController pushViewController:attentionVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.CellHeightBlock) {
        return self.CellHeightBlock();
    }else{
        return .0f;
    }
}

@end
