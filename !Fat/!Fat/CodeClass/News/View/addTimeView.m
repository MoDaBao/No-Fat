//
//  addTimeView.m
//  No!Fat 666
//
//  Created by hu胡洁佩 on 16/4/20.
//  Copyright © 2016年 胡洁佩. All rights reserved.
//

#import "addTimeView.h"
#import "AddTimeDetailViewController.h"
#import "AddTimeListModel.h"
#import "AddTimeListModelCell.h"
#import "AddTimeNoImageModelCell.h"
#import "MyActivityIndicatorView.h"

@interface addTimeView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) CGFloat(^cellHeightBlock)();//block cell的高度

@property (nonatomic, strong)MyActivityIndicatorView *myActivityIndicatorView;
@end

@implementation addTimeView

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
      
        [self requestData];
        
    }
    return self;
}

- (void)requestData {
    [NetWorkRequestManager requestWithType:GET url:ZUIXINLIST_URL dic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic%@", dic);
        
        NSArray *arr = dic[@"feeds"];
        for (NSDictionary *dataDic in arr) {
            AddTimeListModel *model = [[AddTimeListModel alloc] init];
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
        
    }];
}

- (void)requestDataMore {
    [NetWorkRequestManager requestWithType:GET url:ZUIXINLISTMORE_URL dic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic%@", dic);
        
        NSArray *arr = dic[@"feeds"];
        for (NSDictionary *dataDic in arr) {
            AddTimeListModel *model = [[AddTimeListModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataList addObject:model];
        }
        
        //        NSLog(@"datalist%@",arr );
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];

        });
        
    } error:^(NSError *error) {
        
    }];
}


- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.frame.size.width , self.frame.size.height ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddTimeListModelCell" bundle:nil] forCellReuseIdentifier:@"AddTimeListModelCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AddTimeNoImageModelCell" bundle:nil] forCellReuseIdentifier:@"AddTimeNoImageModelCell"];
    
    [self addSubview:_tableView];
    
    
    
//    //下拉刷新
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDataMore)];
//    
//    //上拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddTimeListModel *model = self.dataList[indexPath.row];

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
        [cell.commentBT addTarget:self action:@selector(commentUser:) forControlEvents:UIControlEventTouchUpInside];
        [cell.attentionBT addTarget:self action:@selector(attentionPerson:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
        }else {
            AddTimeNoImageModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddTimeNoImageModelCell"];
            if (!cell) {
                 cell = [[NSBundle mainBundle]loadNibNamed:@"AddTimeNoImageModelCell" owner:nil  options:nil].lastObject;
            }
          [cell setDataWithModel:model];
            self.cellHeightBlock = ^{
                return cell.cellHeight;
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
              [cell.commentBT addTarget:self action:@selector(commentUser:) forControlEvents:UIControlEventTouchUpInside];
           return cell;

}
    
  
    
    
    //测试
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"1111%ld", indexPath.row];
}

//评论按钮的方法
- (void)commentUser:(UIButton *)sender {
    
    UIView *v = [sender superview];//获取父类view
    AddTimeListModelCell *cell = (AddTimeListModelCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];//获取cell对应的
    RecommendListModel *model = self.dataList[indexpath.row];
    ComentListViewController *comment = [[ComentListViewController alloc] init];
    //    RecommendViewController *comment = [[RecommendViewController alloc] init];
    comment.feedId = model.ID;
    NSLog(@"%@", model.ID);
    comment.model = model;
    [_parent.navigationController pushViewController:comment animated:YES];
}


- (void)attentionPerson:(UIButton *)sender {
    UIView *v = [sender superview];//获取父类view
    AddTimeListModelCell *cell = (AddTimeListModelCell *)[v superview];//获取cell
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];//获取cell对应的
    RecommendListModel *model = self.dataList[indexpath.row];
    [NetWorkRequestManager requestWithType:POST url:@"http://api.fit-time.cn/ftsns/follow" dic:@{@"user_id":model.userId} finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", dic);
        
    } error:^(NSError *error) {
        
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellHeightBlock) {
        return self.cellHeightBlock();
    }else {
        return 0.f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddTimeListModel *model = self.dataList[indexPath.row];
    AddTimeDetailViewController *addTimeVC = [[AddTimeDetailViewController alloc] init];
    
    addTimeVC.feedId = model.ID;
    addTimeVC.model = model;
    [_parent.navigationController pushViewController:addTimeVC animated:YES];
    
}
@end
