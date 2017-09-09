//
//  GKWrapViewController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKWrapViewController.h"
#import "GKWrapNavigationController.h"

static NSValue *gk_wrapTabBarRectValue;

@interface GKWrapViewController ()

@property (nonatomic, strong) __kindof UIViewController *contentViewController;

@property (nonatomic, strong) GKWrapNavigationController *wrapNavigationController;

@end

@implementation GKWrapViewController

+ (instancetype)wrapViewControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

// 包装过程
- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        // 1. 第一次包装
        self.wrapNavigationController = [GKWrapNavigationController wrapNavigationControllerWithViewController:viewController];
        
        // 2. 再次包装
        [self addChildViewController:self.wrapNavigationController];
        [self.wrapNavigationController didMoveToParentViewController:self];
        
        // 3. 记录控制器
        self.contentViewController = viewController;
        
        self.wrapNavigationController.gk_wrapViewContorller = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加视图
    [self.view addSubview:self.wrapNavigationController.view];
    self.wrapNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.wrapNavigationController.view.frame = self.view.bounds;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.tabBarController && !gk_wrapTabBarRectValue) {
        gk_wrapTabBarRectValue = [NSValue valueWithCGRect:self.tabBarController.tabBar.frame];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.translucent = YES;
    if (self.tabBarController && !self.tabBarController.tabBar.hidden && gk_wrapTabBarRectValue) {
        self.tabBarController.tabBar.frame = gk_wrapTabBarRectValue.CGRectValue;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.tabBarController && self.contentViewController.hidesBottomBarWhenPushed) {
        self.tabBarController.tabBar.frame = CGRectZero;
    }
}

- (BOOL)shouldAutorotate {
    return self.contentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.contentViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.contentViewController.preferredInterfaceOrientationForPresentation;
}

- (BOOL)becomeFirstResponder {
    return [self.contentViewController becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [self.contentViewController canBecomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.contentViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.contentViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.contentViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.contentViewController.hidesBottomBarWhenPushed;
}

- (NSString *)title {
    return self.contentViewController.title;
}

- (UITabBarItem *)tabBarItem {
    return self.contentViewController.tabBarItem;
}


@end


























