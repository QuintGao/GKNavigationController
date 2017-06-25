//
//  GKNavigationController.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKNavigationController.h"
#import "GKWrapViewController.h"
#import "GKWrapNavigationController.h"
#import "GKFullScreenPanGestureRecognizerDelegate.h"

// 使用static inline创建静态内联函数，方便调用
static inline UIViewController *GKUnWrapViewController(UIViewController *viewController) {
    if ([viewController isKindOfClass:[GKWrapViewController class]]) {
        return ((GKWrapViewController *)viewController).contentViewController;
    }
    return viewController;
}


@interface GKNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<UINavigationControllerDelegate> gk_delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) id popGestureTarget;

@property (nonatomic, strong) GKFullScreenPanGestureRecognizerDelegate *panGestureDelegate;

@end

@implementation GKNavigationController

// 重写构造方法，将控制器先进行包装，再入栈
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        GKWrapViewController *wrapViewController = [GKWrapViewController wrapViewControllerWithViewController:rootViewController];
        self.viewControllers = @[wrapViewController];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        GKWrapViewController *wrapViewController = [GKWrapViewController wrapViewControllerWithViewController:self.viewControllers.firstObject];
        self.viewControllers = @[wrapViewController];
    }
    return self;
}

#pragma mark - Private Method

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        
        _panGesture = [[UIPanGestureRecognizer alloc] init];
        
        _panGesture.maximumNumberOfTouches = 1;
    }
    return _panGesture;
}

- (GKFullScreenPanGestureRecognizerDelegate *)panGestureDelegate {
    if (!_panGestureDelegate) {
        _panGestureDelegate = [GKFullScreenPanGestureRecognizerDelegate new];
        _panGestureDelegate.navigationController = self;
        _panGestureDelegate.popGestureTarget = self.popGestureTarget;
    }
    return _panGestureDelegate;
}

#pragma mark - Override

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setDelegate:self];
    [super setNavigationBarHidden:YES animated:NO];
    
    // 记录系统返回手势的target
    self.popGestureTarget = self.interactivePopGestureRecognizer.delegate;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerPropertyChanged:) name:GKViewControllerPropertyChangedNotification object:nil];
}

- (UIViewController *)gk_visibleViewController {
    return GKUnWrapViewController([super visibleViewController]);
}

- (UIViewController *)gk_topViewController {
    return GKUnWrapViewController([super topViewController]);
}

- (NSArray<UIViewController *> *)gk_viewControllers {
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (UIViewController *vc in [super viewControllers]) {
        [viewControllers addObject:GKUnWrapViewController(vc)];
    }
    return viewControllers;
}

#pragma mark - Notification
- (void)viewControllerPropertyChanged:(NSNotification *)notify {
//    UIViewController *topViewController = self.topViewController;
    
    UIViewController *vc = (UIViewController *)notify.object[@"viewController"];
    
    [self handlePopGestureRecognizer:vc];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self.gk_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.gk_delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 处理手势
    [self handlePopGestureRecognizer:viewController];
    
    [GKNavigationController attemptRotationToDeviceOrientation];
    
    if ([self.gk_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.gk_delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    if ([self.gk_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.gk_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    if ([self.gk_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.gk_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([self.gk_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        [self.gk_delegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    [self handlePopGestureRecognizer:toVC];
    
    if ([self.gk_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.gk_delegate navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
    }
    return nil;
}

// 处理手势操作
- (void)handlePopGestureRecognizer:(UIViewController *)viewController {
    BOOL isRootVC = (viewController == self.viewControllers.firstObject);
    viewController = GKUnWrapViewController(viewController);
    
    // 移除全屏滑动手势，重新处理手势
    if ([self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
    }
    
    if (viewController.gk_interactivePopDisabled) {  // 禁止滑动返回
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled  = NO;
    }else if (viewController.gk_fullScreenPopDisabled) {  // 禁止全屏滑动返回，使用系统滑动返回
        self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled  = !isRootVC;
    }else {   // 全屏滑动返回
        if (!isRootVC) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
        }
        
        // 设置代理
        self.panGesture.delegate = self.panGestureDelegate;
        
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled  = NO;
    }
}

@end
























