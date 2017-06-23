//
//  UIViewController+GKNavigationController.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//  

#import "UIViewController+GKNavigationController.h"
#import "GKNavigationController.h"
#import <objc/runtime.h>

static NSString *const GKWrapViewControllerKey   = @"GKWrapViewControllerKey";
static NSString *const GKNavigationControllerKey = @"GKNavigationControllerKey";

@implementation UIViewController (GKNavigationController)


- (GKWrapViewController *)gk_wrapViewController {
    return objc_getAssociatedObject(self, &GKWrapViewControllerKey);
}

- (void)setGk_wrapViewController:(GKWrapViewController *)gk_wrapViewController {
    objc_setAssociatedObject(self, &GKWrapViewControllerKey, gk_wrapViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GKNavigationController *)gk_navigationController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[GKNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (GKNavigationController *)vc;
}

@end
