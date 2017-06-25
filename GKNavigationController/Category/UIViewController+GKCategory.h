//
//  UIViewController+Category.h
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const GKViewControllerPropertyChangedNotification;

@class GKNavigationController, GKWrapViewController;

@protocol GKNavigationItemCustomProtocol <NSObject>

@optional

- (UIBarButtonItem *)gk_customBackItemWithTarget:(id)target action:(SEL)action;

@end

@interface UIViewController (GKCategory)<GKNavigationItemCustomProtocol>

/** 是否禁止当前控制器的滑动返回(包括全屏返回和边缘返回) */
@property (nonatomic, assign) BOOL gk_interactivePopDisabled;

/** 是否禁止当前控制器的全屏滑动返回 */
@property (nonatomic, assign) BOOL gk_fullScreenPopDisabled;

/** 全屏滑动时，滑动区域距离屏幕左边的最大位置，默认是0，表示全屏都可滑动 */
@property (nonatomic, assign) CGFloat gk_popMaxAllowedDistanceToLeftEdge;

/** 设置导航栏的透明度 */
@property (nonatomic, assign) CGFloat gk_navBarAlpha;


@end

@interface UINavigationController (GKCategory)

- (void)setNavBarAlpha:(CGFloat)alpha;

@end
