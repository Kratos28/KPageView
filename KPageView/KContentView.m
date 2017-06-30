//
//  KContentView.m
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "KContentView.h"
#import "KPageStyle.h"
#import "UIView+KExtension.h"
@interface KContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic ,strong) KPageStyle *style;
@property (nonatomic ,strong) NSArray *childVcs;
@property (nonatomic ,strong) NSArray *title;
@property (nonatomic ,strong) UIViewController *parentVc;
@property (nonatomic ,assign) CGFloat startOffsetX;
//禁止代理
@property (nonatomic ,assign) BOOL isForbidDelegate;
@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation KContentView
static  NSString *kContentCellID = @"kContentCellID";

- (instancetype)initWithFrame:(CGRect)frame ChildVcs:(NSArray *)vcs parentVc:(UIViewController *)parentVc
{
    if (self = [super initWithFrame:frame]) {
        self.childVcs = vcs;
        self.parentVc = parentVc;
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    [self addSubview:self.collectionView];
    for (UIViewController *childVc  in self.childVcs) {
        [self.parentVc addChildViewController:childVc];
    }
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        
    }
    return _collectionView;
}

#pragma mark UICollectionViewDataSource、UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVcs.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *childVc = self.childVcs[indexPath.item];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self collectionViewDidEndScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self collectionViewDidEndScroll];
    }
}
- (void)collectionViewDidEndScroll
{
    NSInteger inIndex = self.collectionView.contentOffset.x / self.collectionView.width;
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentView:inIndex:)])
    {
        [self.delegate contentView:self inIndex:inIndex];
    }

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isForbidDelegate = NO;
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.startOffsetX || _isForbidDelegate) {
        return;
    }
    CGFloat progress = 0;
    NSInteger targetIndex = 0;
    NSInteger sourceIndex = (self.startOffsetX / self.collectionView.width);
    //判断用户是左滑动还是右滑动
    if (scrollView.contentOffset.x > self.startOffsetX) { //左滑动
        targetIndex = sourceIndex + 1;
        progress =  (self.collectionView.contentOffset.x - self.startOffsetX) / self.collectionView.width;
    }else
    {
        targetIndex = sourceIndex - 1;
        progress = (self.startOffsetX - self.collectionView.contentOffset.x) / self.collectionView.width;

    }
    [self.delegate contentView:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];

    
}
#pragma mark KTitleViewDelegate
- (void)titleView:(KTitleView *)titleView currentIndex:(NSInteger)index
{
    self.isForbidDelegate = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}
@end
