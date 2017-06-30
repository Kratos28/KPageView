//
//  KTitleView.m
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "KTitleView.h"
#import "KPageStyle.h"
#import "KContentView.h"
#import "UIView+KExtension.h"
struct ColorRGB
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
};
typedef struct ColorRGB ColorRGB;

@interface KTitleView () <KContentViewDelegate>
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,strong) NSMutableArray *titleLabels;
@property (nonatomic ,strong) KPageStyle *style;
@property (nonatomic, assign) ColorRGB selectRGB;
@property (nonatomic, assign) ColorRGB normalRGB;
@property (nonatomic, assign) ColorRGB deltaRGB;
//底下的ScrollView;
@property (nonatomic ,strong) UIScrollView *scrollView;
//底部线(可选)
@property (nonatomic ,strong) UIView *bottomLine;
//底部遮罩图(可选)
@property (nonatomic ,strong) UIView *coverView;
@end

@implementation KTitleView
{
    
   NSInteger currentIndex;
    
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (ColorRGB)deltaRGB
{
    
    CGFloat deltaR = self.selectRGB.red - self.normalRGB.red;
    CGFloat deltaG = self.selectRGB.green - self.normalRGB.green;
    CGFloat deltaB = self.selectRGB.blue - self.normalRGB.blue;
    ColorRGB RGB = {deltaR,deltaG,deltaB};
    return RGB;
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;

    }
    return _scrollView;
}


-(UIView *)bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor =  self.style.bottomLineColor;
        CGRect frame = CGRectMake(0, self.bounds.size.height - self.style.bottomLineHeight, 0, self.style.bottomLineHeight);
        _bottomLine.frame = frame;
    }
    return _bottomLine;
}

-(UIView *)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor =  self.style.coverBgColor;
        _coverView.alpha = self.style.coverAlpha;
    }
    return _coverView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(KPageStyle *)style title:(NSArray *)titles
{
    if (self = [super initWithFrame:frame]) {
        
        self.style = style;
        self.titles = titles;
        [self setupUI];
    }
    return self;
    
}

- (void)setupUI
{
    [self addSubview:self.scrollView];
    [self setupTitleLabels];
    [self setupLabelsFrame];
    [self setupBottomLine];
    [self setupCoverView];
    
}
- (void)setupTitleLabels
{
    for (int i = 0; i<self.titles.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.tag = i;
        label.text = self.titles[i];
        label.textColor = i == 0 ? self.style.selectColor : self.style.normalColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:self.style.fontSize];
        [self.scrollView addSubview:label];
        [self.titleLabels addObject:label];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        label.userInteractionEnabled = YES;
    }
}

- (void)setupCoverView
{
    if (self.style.isShowCoverView == NO) {
        return;
    }
    [self.scrollView insertSubview:self.coverView atIndex:0];
    UILabel *firstLabel = self.titleLabels.firstObject;
    CGFloat coverW = firstLabel.width;
    CGFloat coverH = self.style.coverHeight;
    CGFloat coverX = firstLabel.x;
    CGFloat coverY = (firstLabel.height - coverH) * 0.5;
    if (self.style.isScrollEnable)
    {
        coverX -= self.style.coverMargin;
        coverW += 2 * self.style.coverMargin;
    }
    self.coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    self.layer.cornerRadius = self.style.coverRadius;
    self.layer.masksToBounds = true;
    
   
}
- (void)setupBottomLine
{
    if (self.style.isShowBottomLine == NO) {
        return;
    }
    
    [self.scrollView addSubview:self.bottomLine];
    UILabel *label = self.titleLabels.firstObject;
    self.bottomLine.x = label.x;
    self.bottomLine.width = label.width;
}
- (void)setupLabelsFrame
{
    
    CGFloat labelH = self.style.titleHeight;
    CGFloat labelY = 0;
    CGFloat labelW = 0;
    CGFloat labelX = 0;
    
    NSInteger count = self.titleLabels.count;
    for (NSInteger i = 0;i<count ; i++)
    {
        UILabel *titleLabel = self.titleLabels[i];
        if (self.style.isScrollEnable)
        {
            labelW = [(NSString *)self.titles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :titleLabel.font } context:nil].size.width;
            labelX = i == 0 ? self.style.titleMargin * 0.5 : CGRectGetMaxX([self.titleLabels[i-1]frame]) + self.style.titleMargin;
        }else
        {
            labelW = self.bounds.size.width / count;
            labelX = labelW * i;
        }
        titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    }
    // 设置scale属性
    if (self.style.isScaleEnable) {
        [(UILabel *)self.titleLabels.firstObject setTransform:CGAffineTransformMakeScale(self.style.maxScale, self.style.maxScale)];
    }
    if (self.style.isScrollEnable) {
        UILabel *label = self.titleLabels.lastObject;
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(label.frame) + self.style.titleMargin * 0.5, 0);
    }
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes
{
    UILabel *label =  (UILabel *)tapGes.view;
    if (label.tag == currentIndex) return;
    [self setTargetLabel:label];
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:currentIndex:)]) {
        [self.delegate titleView:self currentIndex:currentIndex];
    }
}

- (void)setTargetLabel:(UILabel *)targetLabel
{
    UILabel *sourceLabel = self.titleLabels[currentIndex];
    sourceLabel.textColor = self.style.normalColor;
    targetLabel.textColor = self.style.selectColor;
    currentIndex = targetLabel.tag;
    [self adjustLabelPosition:targetLabel];
    
    //调整缩放
    if (self.style.isScaleEnable) {
        [UIView animateWithDuration:0.25 animations:^{
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.maxScale, self.style.maxScale);
        }];
    }
    
    
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomLine.frame = CGRectMake(targetLabel.frame.origin.x, 0, targetLabel.frame.size.width, 0);
        }];
    }
    
    if ((self.style.isShowCoverView)) {
        CGFloat coverX = self.style.isScrollEnable ? (targetLabel.frame.origin.x - self.style.coverMargin ) : targetLabel.frame.origin.x;
        CGFloat coverW = self.style.isScrollEnable ? (targetLabel.frame.size.width + self.style.coverMargin * 2 ) : targetLabel.frame.size.width;
        [UIView animateWithDuration:0.25 animations:^{
            self.coverView.frame = CGRectMake(coverX, 0, coverW, 0);
        }];
        
    }
}

//调整位置
- (void)adjustLabelPosition:(UILabel *)targetLabel
{
    if (self.style.isScaleEnable == NO) return ;
    CGFloat offsetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    if (offsetX > self.scrollView.contentSize.width - self.scrollView.bounds.size.width) {
        offsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}



- (void)contentView:(KContentView *)contentView inIndex:(NSInteger)index
{
    currentIndex = index;
    [self adjustLabelPosition:self.titleLabels[index]];
}
- (void)contentView:(KContentView *)contentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress
{
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    sourceLabel.textColor = [UIColor colorWithRed:self.selectRGB.red - progress * self.deltaRGB.red green:self.selectRGB.green - progress * self.deltaRGB.green blue:self.selectRGB.blue - progress * self.deltaRGB.blue alpha:1.0];
    targetLabel.textColor = [UIColor colorWithRed:self.normalRGB.red + progress * self.deltaRGB.red green:self.normalRGB.green + progress * self.deltaRGB.green blue:self.selectRGB.blue + progress * self.deltaRGB.blue alpha:1.0];
    
    
    if (self.style.isScaleEnable) {
        CGFloat deltaScale = self.style.maxScale - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.maxScale - progress * deltaScale, self.style.maxScale - progress * deltaScale);
          sourceLabel.transform = CGAffineTransformMakeScale(1.0 + progress * deltaScale, 1.0 + progress * deltaScale);
    }
    if (self.style.isShowBottomLine) {
        CGFloat deltaX =  targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        CGFloat deltaW =  targetLabel.frame.size.width - sourceLabel.frame.size.width;
        self.bottomLine.x = sourceLabel.x + progress * deltaX;
        self.bottomLine.width = sourceLabel.width + progress * deltaW;

    }
    
    if (self.style.isShowCoverView) {
        CGFloat deltaX =  targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        CGFloat deltaW =  targetLabel.frame.size.width - sourceLabel.frame.size.width;
        self.coverView.width = self.style.isScrollEnable ? (sourceLabel.width + 2 * self.style.coverMargin + deltaW * progress) : (sourceLabel.width + deltaW * progress);
        self.coverView.x = self.style.isScrollEnable ? (sourceLabel.frame.origin.x - self.style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress);
    }
}

- (void)setCurrentIndex:(NSInteger)index
{
    [self setTargetLabel:self.titleLabels[index]];
}


@end












@interface UIColor (getColor)
- (ColorRGB )getRGB;
@end

@implementation UIColor (getColor)

- (ColorRGB )getRGB
{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    [self getRed:&red green:&green blue:&blue alpha:nil];
//    return @{@"red": @(red *255),
//             @"green": @(green *255),
//             @"blue": @(blue *255)};
     ColorRGB RGB = {red,green,blue};
    return RGB;
}

@end


