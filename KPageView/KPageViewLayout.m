//
//  KPageViewLayout.m
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "KPageViewLayout.h"
#import "UIView+KExtension.h"

@interface KPageViewLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cellAttr;
@end

@implementation KPageViewLayout

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)cellAttr
{
    if (_cellAttr == nil) {
        _cellAttr = [NSMutableArray array];
    }
    return _cellAttr;
}

- (void)prepareLayout
{
    [super prepareLayout];
    if (self.collectionView ==nil) return;
    NSUInteger sectionCount = self.collectionView.numberOfSections;
    CGFloat itemW = (self.collectionView.width - self.sectionInset.left - self.sectionInset.right - ((self.cols - 1) * self.itemSpacing)) / self.cols;
    CGFloat itemH = (self.collectionView.height - self.sectionInset.top - self.sectionInset.bottom - ((self.rows - 1) * self.itemSpacing)) / self.rows;
    for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
       NSUInteger itemCount =  [self.collectionView numberOfItemsInSection:sectionIndex];
        for (int itemIndex = 0;  itemIndex< itemCount; itemIndex++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
           UICollectionViewLayoutAttributes *attr =  [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            NSUInteger pageIndex = itemIndex / (self.rows *self.cols);
            NSInteger pageItemIndex = itemIndex % (self.rows * self.cols);
            
            NSInteger rowIndex = (int)pageItemIndex / (int)self.cols;
            NSInteger colIndex =  (int)pageItemIndex % (int)self.cols;
           CGFloat itemY = self.sectionInset.top + (itemH + self.lineSpacing) * rowIndex;
            CGFloat ItemX = (self.pageCount  + pageIndex) *self.collectionView.width + self.sectionInset.left + (itemW + self.itemSpacing) * colIndex;
            attr.frame = CGRectMake(ItemX, itemY, itemW, itemH);
            [self.cellAttr addObject:attr];
        }
        // 计算该组一共占据多少页
        self.pageCount += (itemCount - 1) / (self.cols * self.rows) + 1;

    }
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.cellAttr;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.pageCount * self.collectionView.width, 0);
}

@end
