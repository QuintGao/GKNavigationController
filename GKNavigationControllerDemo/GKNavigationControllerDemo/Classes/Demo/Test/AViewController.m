//
//  AViewController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/9/5.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "AViewController.h"
#import "BViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 400, 60, 20);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.title = @"A";
}

- (void)btnAction {
    BViewController *bvc = [BViewController sharedInstance];
    
    [self.navigationController pushViewController:bvc animated:YES];
}

@end
