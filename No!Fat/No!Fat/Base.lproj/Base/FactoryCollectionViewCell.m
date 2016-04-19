//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell


+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model {
    
    NSString *name = NSStringFromClass([model class]);
    
        Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell",name]);
    
    BaseCollectionViewCell *cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    
    return cell;
}


+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {
    
    NSString *name = NSStringFromClass([model class]);
    
//    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell",name]);
    
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
    
    return cell;
}

@end
