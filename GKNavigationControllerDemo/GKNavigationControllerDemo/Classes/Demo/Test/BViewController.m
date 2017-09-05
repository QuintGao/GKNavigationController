//
//  BViewController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/9/5.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "BViewController.h"
#import "CViewController.h"

@interface BViewController ()

@end

@implementation BViewController

+ (instancetype)sharedInstance {
    static BViewController *bvc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bvc = [BViewController new];
    });
    return bvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, 400, 60, 20);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.title = @"B";
}

- (void)btnAction {
    CViewController *cvc = [CViewController new];
    
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
