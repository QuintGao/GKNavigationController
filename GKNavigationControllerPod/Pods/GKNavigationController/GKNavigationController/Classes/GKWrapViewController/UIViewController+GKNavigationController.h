//
//  UIViewController+GKNavigationController.h
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//  此类用户获取方便开发，用户不必关心

#import <UIKit/UIKit.h>

@class GKWrapViewController, GKNavigationController;

@interface UIViewController (GKNavigationController)

/**
 控制器对应的包装后的控制器
 */
@property (nonatomic, strong) GKWrapViewController *gk_wrapViewController;

/**
 控制器的根控制器
 */
@property (nonatomic, strong, readonly) GKNavigationController *gk_navigationController;

@end
