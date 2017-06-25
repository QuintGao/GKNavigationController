//
//  UIViewController+Category.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "UIViewController+GKCategory.h"
#import "UIImage+GKCategory.h"
#import <objc/runtime.h>
#import "GKNavigationController.h"
#import "GKWrapViewController.h"

NSString *const GKViewControllerPropertyChangedNotification = @"GKViewControllerPropertyChangedNotification";

static NSString *const GKInteractivePopKey = @"GKInteractivePopKey";
static NSString *const GKFullScreenPopKey  = @"GKFullScreenPopKey";
static NSString *const GKPopMaxDistanceKey = @"GKPopMaxDistanceKey";
static NSString *const GKNavBarAlphaKey    = @"GKNavBarAlphaKey";

@implementation UIViewController (GKCategory)

- (BOOL)gk_interactivePopDisabled {
    return [objc_getAssociatedObject(self, &GKInteractivePopKey) boolValue];
}

- (void)setGk_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, &GKInteractivePopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉GKNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:GKViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (BOOL)gk_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, &GKFullScreenPopKey) boolValue];
}

- (void)setGk_fullScreenPopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, &GKFullScreenPopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉GKNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:GKViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (CGFloat)gk_popMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, &GKPopMaxDistanceKey) floatValue];
}

- (void)setGk_popMaxAllowedDistanceToLeftEdge:(CGFloat)distance {
    objc_setAssociatedObject(self, &GKPopMaxDistanceKey, @(distance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变是，发送通知，告诉GKNavigationController，让其做出相应处理
    [[NSNotificationCenter defaultCenter] postNotificationName:GKViewControllerPropertyChangedNotification object:@{@"viewController": self}];
}

- (CGFloat)gk_navBarAlpha {
    return [objc_getAssociatedObject(self, &GKNavBarAlphaKey) floatValue];
}

- (void)setGk_navBarAlpha:(CGFloat)gk_navBarAlpha {
    objc_setAssociatedObject(self, &GKNavBarAlphaKey, @(gk_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.navigationController setNavBarAlpha:gk_navBarAlpha];
}

#pragma mark GKNavigationItemCustomProtocol
- (UIBarButtonItem *)gk_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
    [btn sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end

@implementation UINavigationController (GKCategory)

// 设置导航栏透明度
- (void)setNavBarAlpha:(CGFloat)alpha {
    UIView *barBackgroundView = [self.navigationBar.subviews objectAtIndex:0]; // _UIBarBackground
    UIImageView *backgroundImageView = [barBackgroundView.subviews objectAtIndex:0]; // UIImageView
    
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        }else {
            UIView *backgroundEffectView = [barBackgroundView.subviews objectAtIndex:1]; // UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    }else {
        barBackgroundView.alpha = alpha;
    }
    // 底部分割线
    self.navigationBar.clipsToBounds = alpha == 0.0;
}

@end
























