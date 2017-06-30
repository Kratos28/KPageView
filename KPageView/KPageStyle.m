//
//  KPageStyle.m
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "KPageStyle.h"

@implementation KPageStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置默认值
        self.titleHeight = 44;
        self.normalColor = [UIColor whiteColor];
        self.selectColor = [UIColor orangeColor];
        self.fontSize = 15;
        self.titleMargin = 30;
        self.bottomLineColor = [UIColor orangeColor];
        self.bottomLineHeight = 2;
        self.maxScale = 1.2;
        self.coverBgColor = [UIColor blackColor];
        self.coverAlpha = 0.4;
        self.coverMargin = 8;
        self.coverHeight = 25;
        self.coverRadius = 12;
        self.pageControlHeight = 20;
    }
    return self;
}
@end
