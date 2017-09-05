//
//  GKWrapNavigationController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKWrapNavigationController.h"
#import "GKWrapViewController.h"
#import "UIViewController+GKNavigationController.h"
#import "GKNavigationController.h"

@interface GKWrapNavigationController ()

@end

@implementation GKWrapNavigationController

+ (instancetype)wrapNavigationControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.viewControllers = @[viewController];
        
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            [self setNavigationBarHidden:YES animated:NO];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 禁用包装的控制器的返回手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    GKNavigationController *nav = (GKNavigationController *)self.navigationController;
    
    // push一个包装后的控制器
    GKWrapViewController *wrapViewController = [GKWrapViewController wrapViewControllerWithViewController:viewController];
    viewController.gk_wrapViewController = wrapViewController;
    
    if ([viewController respondsToSelector:@selector(gk_customBackItemWithTarget:action:)]) {
        viewController.navigationItem.leftBarButtonItem = [viewController gk_customBackItemWithTarget:self action:@selector(backAction:)];
    }else {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    }
    
    [nav pushViewController:wrapViewController animated:YES];
}

- (void)backAction:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (self.navigationController.viewControllers.count > 1) {
        return [self.navigationController popViewControllerAnimated:animated];
    }else {
        if (self.navigationController.navigationController.navigationController) {
            // 暂时的解决办法，用于处理push到UITabBarController的情况
            return [self.navigationController.navigationController.navigationController popViewControllerAnimated:animated];
        }else if (self.navigationController.navigationController) {
            return [self.navigationController.navigationController popViewControllerAnimated:animated];
        }else {
            return [self.navigationController popViewControllerAnimated:animated];
        }
    }
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // pop到指定控制器时应找到对应的GKWrapViewController
    GKWrapViewController *wrapViewController = viewController.gk_wrapViewController;
    return [self.navigationController popToViewController:wrapViewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.navigationController.delegate = delegate;
}

@end
