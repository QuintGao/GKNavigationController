//
//  GKDemoBaseViewController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKDemoBaseViewController.h"

@interface GKDemoBaseViewController ()

@end

@implementation GKDemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)showBackBtn {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)btnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
