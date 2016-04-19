//
//  FactoryCollectionViewCell.h
//  Leisure
//
//  Created by 莫大宝 on 16/3/31.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"

@interface FactoryCollectionViewCell : NSObject


+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model;

+ (BaseCollectionViewCell *)createCollectionViewCell:(BaseModel *)model andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;

@end
