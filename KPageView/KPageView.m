//
//  KPageView.m
//  KPageView
//
//  Created by Kratos on 2017/6/29.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "KPageView.h"
#import "KPageViewLayout.h"
#import "KTitleView.h"
#import "UIView+KExtension.h"
#import "KPageStyle.h"
#import "KContentView.h"

@interface KPageView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) KPageStyle *style;
@property (nonatomic ,strong) NSArray *childVcs;
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,strong) UIViewController *parentVc;
@property (nonatomic ,strong) KPageViewLayout* layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) KTitleView *titleView;
@end

@implementation KPageView
{
    NSInteger currentSection;
}

- (KTitleView *)titleView
{
    if (_titleView == nil) {
        CGRect titleFrame = CGRectMake(0, 0, self.width, self.style.titleHeight);
        _titleView = [[KTitleView alloc]initWithFrame:titleFrame style:self.style title:self.titles];
    
    }
    return _titleView;
}


- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style titles:(NSArray *)titles childVcs:(NSArray *)childVcs parentVc:(UIViewController *)parentVc
{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.titles = titles;
        self.childVcs = childVcs;
        self.parentVc = parentVc;
        [self setupContentUI];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style titles:(NSArray *)titles layout:(KPageViewLayout *)layout
{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.titles = titles;
        self.layout = layout;
        [self setupCollectionUI];
    }
    return self;
}
- (void)setupContentUI
{
    

    [self addSubview:self.titleView];

    
    CGRect contentFrame = CGRectMake(0, self.style.titleHeight, self.width, self.height - self.style.titleHeight);
    KContentView *conentView = [[KContentView alloc]initWithFrame:contentFrame ChildVcs:self.childVcs parentVc:self.parentVc];
    conentView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) green:arc4random_uniform(255) blue:arc4random_uniform(255) alpha:1];
    [self addSubview:conentView];
    conentView.delegate = self.titleView;

    self.titleView.delegate = conentView;
    
}
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        CGRect pageControllerFrame = CGRectMake(0, self.collectionView.maxY, self.width, self.style.pageControlHeight);
        _pageControl = [[UIPageControl alloc]initWithFrame:pageControllerFrame];
        _pageControl.numberOfPages = 4;
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (void)setupCollectionUI
{
    [self addSubview:self.titleView];
    CGRect collectionFrame =  CGRectMake(0, self.style.titleHeight, self.width, self.height - self.style.titleHeight-self.style.pageControlHeight);
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:collectionFrame collectionViewLayout:self.layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollsToTop =NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self. collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [self addSubview:self.pageControl];
    

}

- (void)collectionViewDidEndScroll
{
    CGPoint point = CGPointMake(self.layout.sectionInset.left + self.collectionView.contentOffset.x, self.layout.sectionInset.top);
    NSIndexPath *indexPath =  [self.collectionView indexPathForItemAtPoint:point];
    if (indexPath == nil) {
        return;
    }

    
    // 2.如果发现组(section)发生了改变, 那么重新设置pageControl的numberOfPages
    if (indexPath.section != currentSection) {
        //改变pageControl的numberOfPages
        
        NSInteger itemCount = 0;
        if ([self.dataSource respondsToSelector:@selector(pageView:numberOfItemInSection:)]) {
            itemCount = [self.dataSource pageView:self numberOfItemInSection:indexPath.section];
        }
        
        self.pageControl.numberOfPages = (itemCount -1) / (self.layout.rows *self.layout.cols) + 1;
        
        
        // 记录最新的currentSection
        currentSection = indexPath.section;
        
        // 让titleView选中最新的title
        [self.titleView setCurrentIndex:currentSection];
    }
    
    // 3.显示pageControl正确的currentPage
    CGFloat pageIndex = indexPath.item / 8;
    self. pageControl.currentPage = pageIndex;

}

- (UICollectionViewCell *)dequeueReusableCell:(NSString *)identifier  forIndexPath:(NSIndexPath*)indexPath
{
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)registerCell:(Class)cellClass identifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

#pragma mark UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionInPageView:)]) {
        NSLog(@"%ld", [self.dataSource numberOfSectionInPageView:self]);
       return  [self.dataSource numberOfSectionInPageView:self];
    }
    return 0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger itemCount = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageView:numberOfItemInSection:)]) {
        itemCount = [self.dataSource pageView:self numberOfItemInSection:section];
    }else
    {
        return itemCount;
    }
    if (section ==0) {
        self.pageControl.numberOfPages = (itemCount - 1) / (self.layout.cols * self.layout.rows) + 1;
    }
    return itemCount;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource pageView:self cellForItemAtIndexPath:indexPath];
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageView:didSelectedAtIndexPath:)]) {
        return [self.delegate pageView:self didSelectedAtIndexPath:indexPath];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self collectionViewDidEndScroll];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self collectionViewDidEndScroll];
}

@end
