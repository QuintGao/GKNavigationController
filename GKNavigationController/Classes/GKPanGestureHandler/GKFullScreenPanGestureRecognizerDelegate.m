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
    
    // 禁止手势滑动返回
    if (topContentViewController.gk_interactivePopDisabled) return NO;
    
    // 正在做过渡动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;
    
    // 最大滑动距离，全屏滑动时有效
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowDistance  = topContentViewController.gk_popMaxAllowedDistanceToLeftEdge;
    if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance && !topContentViewController.gk_fullScreenPopDisabled) {
        return NO;
    }
    
    // 左滑
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !topContentViewController.gk_fullScreenPopDisabled) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:gestureRecognizer.view];
        BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
        CGFloat multiplier = isLeftToRight ? 1 : -1;
        if ((translation.x * multiplier) <= 0) {
            return NO;
        }
    }
    
    return YES;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

@end
