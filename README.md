# KPageView
KPageView 模仿网易新闻选项卡、PageViewController、PageView
## <a></a>控制器模式
![(下拉刷新02-动画图片)](http://images0.cnblogs.com/blog2015/497279/201506/141204402238389.gif)

```objc

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
    KPageStyle *style = [[KPageStyle alloc]init];
    //tileView是否可以滚动
    style.isScrollEnable = YES;
    //tileView是否可以缩放
//    style.isScaleEnable = YES;
    //tileView是否有揭盖
//    style.isShowCoverView = YES;
    //tileView是否有下划线
    style.isShowBottomLine = YES;
    NSArray *titles = @[@"123", @"游戏", @"haha游戏", @"ha", @"hahahaha", @"haha", @"fff", @"weff",@"wer"];
    NSMutableArray *childVC = [NSMutableArray array];
    for (NSString *titile  in titles) {
        UIViewController *vc = [[UIViewController alloc]init];
        
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random()  %255/255.0 alpha:1];
        [childVC addObject:vc];
    }
    CGRect pageFrame = CGRectMake(0, 64, self.view.width, self.view.height -64);
    KPageView *pageView = [[KPageView alloc]initWithFrame:pageFrame style:style titles:titles childVcs:childVC parentVc:self];
    pageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:pageView];
    

}

@end

```
