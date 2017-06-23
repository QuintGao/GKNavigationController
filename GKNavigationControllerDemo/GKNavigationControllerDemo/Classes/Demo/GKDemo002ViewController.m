//
//  GKSecondViewController.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/21.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKDemo002ViewController.h"
#import "GKNavigationController.h"
#import "GKDemo003ViewController.h"

@interface GKDemo002ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation GKDemo002ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gk_navBarAlpha = 0.0;
    
    self.navigationItem.title = @"控制器002";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    self.scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height + 200);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    // 禁用滑动返回
    self.gk_interactivePopDisabled = YES;
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 60, 20);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *label = [UILabel new];
    label.text = @"我是透明导航栏控制器，我禁用了滑动返回手势，我还实现了导航栏渐变效果哦";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, 200, self.view.frame.size.width, 0);
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    if (self.tabBarController.navigationController) {
        [self showBackBtn];
    }
}

- (void)btnAction {
    GKDemo003ViewController *demo003VC = [GKDemo003ViewController new];
    demo003VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:demo003VC animated:YES];
}

// 自定义返回按钮：GKNavigationController.useSystemBackBarButtonItem 为NO时生效

- (UIBarButtonItem *)gk_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - UIScrollViewDelegate

// 渐变导航栏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentY = scrollView.contentOffset.y;
    
    NSLog(@"%f", contentY);
    
    if (contentY <= 0) {
        self.gk_navBarAlpha = 0;
        return;
    }
    
    // 渐变区间 (0 - 80)
    if (contentY > 0 && contentY < 160) {
        CGFloat alpha = contentY / (160 - 0);
        
        self.gk_navBarAlpha = alpha;
    }else {
        self.gk_navBarAlpha = 1.0;
    }
    
    
    
    
    
    
    
}

@end
