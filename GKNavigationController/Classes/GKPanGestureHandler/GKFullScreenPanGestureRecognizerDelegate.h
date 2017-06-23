//
//  GKFullScreenPanGestureRecognizerDelegate.h
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//  这个类主要用来处理全屏滑动手势的代理方法

#import <UIKit/UIKit.h>

@class GKNavigationController;

@interface GKFullScreenPanGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

/**
 根控制器
 */
@property (nonatomic, weak) GKNavigationController *navigationController;

/**
 系统返回手势的target
 */
@property (nonatomic, strong) id popGestureTarget;

@end
