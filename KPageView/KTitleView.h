//
//  KTitleView.h
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KContentView.h"

@class KPageStyle,KTitleView;
@protocol KTitleViewDelegate <NSObject>
- (void)titleView:(KTitleView *)titleView currentIndex:(NSInteger)index;
@end



@interface KTitleView : UIView <KContentViewDelegate>
@property (nonatomic ,strong) id<KTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style title:(NSArray *)titles;
- (void)setCurrentIndex:(NSInteger)index;
@end
