//
//  ViewController.m
//  KPageView
//
//  Created by Kratos on 2017/6/28.
//  Copyright © 2017年 Kratos. All rights reserved.
//

#import "ViewController.h"
#import "KPageStyle.h"
#import "UIView+KExtension.h"
#import "KPageView.h"
#import "KPageViewLayout.h"
@interface ViewController () <KPageViewDataSource>

@end

@implementation ViewController
static   NSString   *kCollectionViewCellID = @"kCollectionViewCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    KPageStyle *style = [[KPageStyle alloc]init];
//    //tileView是否可以滚动
//    style.isScrollEnable = YES;
//    //tileView是否可以缩放
////    style.isScaleEnable = YES;
//    //tileView是否有揭盖
////    style.isShowCoverView = YES;
//    //tileView是否有下划线
//    style.isShowBottomLine = YES;
//    NSArray *titles = @[@"123", @"游戏", @"haha游戏", @"ha", @"hahahaha", @"haha", @"fff", @"weff",@"wer"];
//    NSMutableArray *childVC = [NSMutableArray array];
//    for (NSString *titile  in titles) {
//        UIViewController *vc = [[UIViewController alloc]init];
//        
//        vc.view.backgroundColor = [UIColor colorWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random()  %255/255.0 alpha:1];
//        [childVC addObject:vc];
//    }
//    CGRect pageFrame = CGRectMake(0, 64, self.view.width, self.view.height -64);
//    KPageView *pageView = [[KPageView alloc]initWithFrame:pageFrame style:style titles:titles childVcs:childVC parentVc:self];
//    pageView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:pageView];
//    
    
    //TiteView的样式对象
    KPageStyle *style = [[KPageStyle alloc]init];
    //tileView是否可以滚动
    style.isScrollEnable = NO;
    //collectionView布局方式
    KPageViewLayout *layout = [[KPageViewLayout alloc]init];
    //上下左右边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //行间距
    layout.lineSpacing = 10;
    //列间距
    layout.itemSpacing = 10;
    //设置多少列
    layout.cols = 4;
    //设置多少行
    layout.rows = 2;
    
     NSArray *titles = @[@"123", @"游戏游戏游戏", @"haha游戏",@"ads"];
    CGRect pageFrame = CGRectMake(0, 64, self.view.width,300);
    KPageView *pageView = [[KPageView alloc]initWithFrame:pageFrame style:style titles:titles layout:layout];
    pageView.dataSource = self;
    pageView.delegate = self;
    [pageView registerCell:[UICollectionViewCell class] identifier:kCollectionViewCellID];
    pageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:pageView];
}



- (NSInteger)numberOfSectionInPageView:(KPageView *)pageView
{
    return 4;
}

- (NSInteger)pageView:(KPageView *)pageView numberOfItemInSection:(NSInteger)section
{
    if (section == 0)  {
        return 12;
    } else if (section == 1) {
        return 30;
    } else if (section == 2) {
        return 7;
    }
    
    return 13;
}
- (UICollectionViewCell *)pageView:(KPageView *)pageView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =  [pageView dequeueReusableCell:kCollectionViewCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0f green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255) /255.0f alpha:1];

    return cell;
}
@end
