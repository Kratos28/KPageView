//
//  KPageViewLayout.h
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPageViewLayout : UICollectionViewLayout
@property (nonatomic ,assign) NSUInteger cols;
@property (nonatomic ,assign) NSUInteger rows;
@property (nonatomic ,assign) CGFloat itemSpacing;
@property (nonatomic ,assign) CGFloat lineSpacing;
@property (nonatomic ,assign) UIEdgeInsets sectionInset;

@end
