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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    KPageStyle *style = [[KPageStyle alloc]init];
    style.isScrollEnable = YES;
    NSArray *titles = @[@"推荐", @"游戏游戏游戏", @"热门游戏", @"趣玩游", @"娱乐", @"热门游戏", @"趣玩游", @"娱乐"];
    NSMutableArray *childVC = [NSMutableArray array];
    for (NSString *titile  in titles) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) green:arc4random_uniform(255) blue:arc4random_uniform(255) alpha:1];
        [childVC addObject:vc];
    }
    CGRect pageFrame = CGRectMake(0, 64, self.view.width, self.view.height -64);
    KPageView *pageView = [[KPageView alloc]initWithFrame:pageFrame style:style titles:titles childVcs:childVC parentVc:self];
    pageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:pageView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
