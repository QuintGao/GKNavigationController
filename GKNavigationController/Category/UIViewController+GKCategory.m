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

static NSString *const GKInteractivePopKey = @"GKInteractivePopKey";
static NSString *const GKFullScreenPopKey  = @"GKFullScreenPopKey";
static NSString *const GKPopMaxDistanceKey = @"GKPopMaxDistanceKey";

@implementation UIViewController (GKCategory)

- (BOOL)gk_interactivePopDisabled {
    return [objc_getAssociatedObject(self, &GKInteractivePopKey) boolValue];
}

- (void)setGk_interactivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, &GKInteractivePopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)gk_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, &GKFullScreenPopKey) boolValue];
}

- (void)setGk_fullScreenPopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, &GKFullScreenPopKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gk_popMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, &GKPopMaxDistanceKey) floatValue];
}

- (void)setGk_popMaxAllowedDistanceToLeftEdge:(CGFloat)distance {
    objc_setAssociatedObject(self, &GKPopMaxDistanceKey, @(distance), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GKNavigationController *)gk_navigationController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[GKNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (GKNavigationController *)vc;
}

- (Class)gk_navigationBarClass {
    return nil;
}

- (void)showTransparentNavbar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
}

#pragma mark GKNavigationItemCustomProtocol
- (UIBarButtonItem *)gk_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
