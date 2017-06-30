//
//  KContentView.h
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KPageStyle , KPageViewLayout,KContentView,KTitleView;
@protocol KTitleViewDelegate;


@protocol KContentViewDelegate <NSObject>
- (void)contentView:(KContentView *)contentView inIndex:(NSInteger)index;

- (void)contentView:(KContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress;
@end
@interface KContentView : UIView 
@property (nonatomic ,weak) id<KContentViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame   ChildVcs:(NSArray *)vcs parentVc:(UIViewController *)parentVc;

@end
