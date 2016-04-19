//
//  FactoryTableViewCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableViewCell.h"
#import "BaseModel.h"

@interface FactoryTableViewCell : NSObject

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model;

+ (BaseTableViewCell *)createTableViewCell:(BaseModel *)model andTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;


@end
