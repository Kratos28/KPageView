//
//  KPageView.h
//  KPageView
//
//  Created by Kratos on 2017/6/29.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPageStyle,KPageViewLayout,KPageView;
@protocol KPageViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionInPageView:(KPageView *)pageView;
- (NSInteger)pageView:(KPageView *)pageView numberOfItemInSection:(NSInteger)section;
- (UICollectionViewCell *)pageView:(KPageView *)pageView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end


@protocol KPageViewDelegate <NSObject>
@optional
- (void)pageView:(KPageView *)pageView didSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface KPageView : UIView

@property (nonatomic ,assign) id<KPageViewDelegate> delegate;
@property (nonatomic ,assign) id<KPageViewDataSource> dataSource;
- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style titles:(NSArray *)titles childVcs:(NSArray *)childVcs parentVc:(UIViewController *)parentVc;
- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style titles:(NSArray *)titles layout:(KPageViewLayout *)layout;


@end
