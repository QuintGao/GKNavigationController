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

@interface GKDemo002ViewController ()

@end

@implementation GKDemo002ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showTransparentNavbar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"控制器002";
    
    // 禁用滑动返回
    self.gk_interactivePopDisabled = YES;
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 100, 60, 20);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *label = [UILabel new];
    label.text = @"我是透明导航栏控制器，我禁用了滑动返回手势";
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, 200, self.view.frame.size.width, 0);
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)btnAction {
    GKDemo003ViewController *demo003VC = [GKDemo003ViewController new];
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

@end
