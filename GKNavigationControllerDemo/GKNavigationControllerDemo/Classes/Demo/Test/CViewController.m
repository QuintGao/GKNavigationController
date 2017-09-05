//
//  CViewController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/9/5.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "CViewController.h"
#import "BViewController.h"

#import "GKNavigationController.h"

#import "UIViewController+GKNavigationController.h"

@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 400, 60, 20);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.title = @"C";
}

- (void)btnAction {
    
    GKNavigationController *nav = self.gk_navigationController;
    
    [nav.gk_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BViewController class]]) {
            
            NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nav.viewControllers];
            
            [viewControllers removeObjectAtIndex:idx];
            nav.viewControllers = viewControllers;
            
            *stop = YES;
        }
    }];
    
    BViewController *bvc = [BViewController sharedInstance];
    
    [self.navigationController pushViewController:bvc animated:YES];
}

@end
