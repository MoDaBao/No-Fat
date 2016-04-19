//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell


+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model {
    //1、将model类名转成字符串
    NSString *name = NSStringFromClass([model class]);
    //2、获取要创建的cell名
    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell",name]);
    //3、创建cell对象
    BaseTableViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    
    return cell;
}


+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model andTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //1、将model类名转成字符串
    NSString *name = NSStringFromClass([model class]);
    //2、获取要创建的cell名
//    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell",name]);
    //3、创建cell对象
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
    
    return cell;
}


@end
