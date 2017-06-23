//
//  GKFullScreenPanGestureRecognizerDelegate.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKFullScreenPanGestureRecognizerDelegate.h"
#import "GKNavigationController.h"

@implementation GKFullScreenPanGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 获取当前控制器的导航栏的最顶层控制器的内容控制器
    UIViewController *topContentViewController = self.navigationController.gk_topViewController;
    
    // 获取系统手势的action
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    // 禁止手势滑动返回
    if (topContentViewController.gk_interactivePopDisabled) return NO;
    
    // 正在做过渡动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;
    
    
    // 自定义手势处理
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        
        // 获取手势的速度位置
        CGPoint velocity = [panGesture velocityInView:panGesture.view];
        if (velocity.x < 0) {  // 向左滑动push操作
            NSLog(@"%@", @"暂不做处理");
        }else {  // 向右滑动pop操作，使用系统的pop方法
            // 首先处理禁止pop的操作--控制器设置的最大滑动距离
            CGPoint beginningLocation = [panGesture locationInView:panGesture.view];
            CGFloat maxAllowDistance  = topContentViewController.gk_popMaxAllowedDistanceToLeftEdge;
            if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance && !topContentViewController.gk_fullScreenPopDisabled) {
                return NO;
            }else {
                // 添加系统的pop操作
                [gestureRecognizer addTarget:self.popGestureTarget action:action];
            }
        }
    }
    return YES;
}

@end
