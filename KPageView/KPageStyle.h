//
//  KPageStyle.h
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//  PageView配置


#import <UIKit/UIKit.h>
@interface KPageStyle : NSObject
  // 是否可以滚动
@property (nonatomic, assign) BOOL isScrollEnable;

/**************Label的属性*********************/
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) CGFloat titleMargin;
/****************end*************************/

// 是否显示滚动条
@property (nonatomic, assign) BOOL isShowBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;
@property (nonatomic, assign) CGFloat bottomLineHeight;

// 是否需要缩放功能
@property (nonatomic, assign) BOOL isScaleEnable;
//最大缩放
@property (nonatomic, assign) CGFloat maxScale;

// 是否需要显示的coverView
@property (nonatomic, assign) BOOL isShowCoverView;
@property (nonatomic, strong) UIColor *coverBgColor;
//揭盖图透明度
@property (nonatomic, assign) CGFloat coverAlpha;
//揭盖图间距
@property (nonatomic, assign) CGFloat coverMargin;
//揭盖图高度
@property (nonatomic, assign) CGFloat coverHeight;
//揭盖圆角
@property (nonatomic, assign) CGFloat coverRadius;
// pageControl的高度
@property (nonatomic, assign) CGFloat pageControlHeight;

@end
