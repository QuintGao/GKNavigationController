//
//  GKNavigationController.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKNavigationController.h"
#import "NSArray+GKCategory.h"

@interface GKContainerViewController()

@property (nonatomic, strong) __kindof UIViewController *contentViewController;

// 当前控制器包装的导航栏
@property (nonatomic, strong) UINavigationController *containerNavigationController;

+ (instancetype)containerViewControllerWithContentViewController:(UIViewController *)viewController;

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController navigationBarClass:(Class)navigationBarClass withPlaceholderController:(BOOL)yesOrNo backBarButtonItem:(UIBarButtonItem *)backItem backTitle:(NSString *)backTitle;

@end

// 使用static inline创建静态内联函数，方便调用
static inline UIViewController *GKUnWrapViewController(UIViewController *viewController) {
    if ([viewController isKindOfClass:[GKContainerViewController class]]) {
        return ((GKContainerViewController *)viewController).contentViewController;
    }
    return viewController;
}

// 使用__attribute((overloadable)) 实现函数重载
__attribute((overloadable)) static inline UIViewController *GKWrapViewController(UIViewController *viewController, Class navigationBarClass, BOOL withPlaceholder, UIBarButtonItem *backItem, NSString *backTitle) {
    if (![viewController isKindOfClass:[GKContainerViewController class]]) {
        return [GKContainerViewController containerViewControllerWithViewController:viewController navigationBarClass:navigationBarClass withPlaceholderController:withPlaceholder backBarButtonItem:backItem backTitle:backTitle];
    }
    return viewController;
}

__attribute((overloadable)) static inline UIViewController *GKWrapViewController(UIViewController *viewController, Class navigationBarClass, BOOL withPlaceholder) {
    if (![viewController isKindOfClass:[GKContainerViewController class]]) {
        return GKWrapViewController(viewController, navigationBarClass, withPlaceholder, nil, nil);
    }
    return viewController;
}

__attribute((overloadable)) static inline UIViewController *GKWrapViewController(UIViewController *viewController, Class navigationBarClass) {
    return GKWrapViewController(viewController, navigationBarClass, NO);
}

@implementation GKContainerViewController

+ (instancetype)containerViewControllerWithContentViewController:(UIViewController *)viewController {
    return [[self alloc] initWithContentViewController:viewController];
}

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController navigationBarClass:(Class)navigationBarClass withPlaceholderController:(BOOL)yesOrNo backBarButtonItem:(UIBarButtonItem *)backItem backTitle:(NSString *)backTitle {
    return [[self alloc] initWithViewController:viewController navigationBarClass:navigationBarClass withPlaceholderController:yesOrNo backBarButtonItem:backItem backTitle:backTitle];
}

- (instancetype)initWithContentViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        self.contentViewController = viewController;
        [self addChildViewController:self.contentViewController];
        [self.contentViewController didMoveToParentViewController:self];
    }
    return self;
}

- (instancetype)initWithViewController:(UIViewController *)viewController navigationBarClass:(Class)navigationBarClass withPlaceholderController:(BOOL)yesOrNo backBarButtonItem:(UIBarButtonItem *)backItem backTitle:(NSString *)backTitle {
    if (self = [super init]) {
        self.contentViewController = viewController;
        self.containerNavigationController = [[GKContainerNavigationController alloc] initWithNavigationBarClass:navigationBarClass toolbarClass:nil];
        
        if (yesOrNo) {
            UIViewController *vc = [UIViewController new];
            vc.title = backTitle;
            vc.navigationItem.backBarButtonItem = backItem;
            self.containerNavigationController.viewControllers = @[vc, viewController];
        }else {
            self.containerNavigationController.viewControllers = @[viewController];
        }
        
        // 如果push 的是一个UITabBarController 需要把导航栏隐藏掉，不然会遮盖子控制器的标题等
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            [self.containerNavigationController setNavigationBarHidden:YES animated:NO];
        }
        
        [self addChildViewController:self.containerNavigationController];
        [self.containerNavigationController didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.containerNavigationController) {
        self.containerNavigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.containerNavigationController.view];
        self.containerNavigationController.view.frame = self.view.bounds;
    }else {
        self.contentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.contentViewController.view];
    }
}

- (BOOL)becomeFirstResponder {
    return [self.contentViewController becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return [self.contentViewController canBecomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.contentViewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.contentViewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.contentViewController.preferredStatusBarUpdateAnimation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return self.contentViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.contentViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.contentViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIView *)rotatingHeaderView {
    return self.contentViewController.rotatingHeaderView;
}

- (nullable UIView *)rotatingFooterView {
    return self.contentViewController.rotatingFooterView;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    return [self.contentViewController viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.contentViewController.hidesBottomBarWhenPushed;
}

- (NSString *)title {
    return self.contentViewController.title;
}

- (UITabBarItem *)tabBarItem {
    return self.contentViewController.tabBarItem;
}

@end

@implementation GKContainerNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithNavigationBarClass:rootViewController.gk_navigationBarClass toolbarClass:nil]) {
        [self pushViewController:rootViewController animated:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    if (self.gk_navigationController.useRootNavigationBarAttributes) {
        self.navigationBar.translucent      = self.navigationController.navigationBar.isTranslucent;
        self.navigationBar.tintColor        = self.navigationController.navigationBar.tintColor;
        self.navigationBar.barTintColor     = self.navigationController.navigationBar.barTintColor;
        self.navigationBar.barStyle         = self.navigationController.navigationBar.barStyle;
        self.navigationBar.backgroundColor  = self.navigationController.navigationBar.backgroundColor;
        
        [self.navigationBar setBackgroundImage:[self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setTitleVerticalPositionAdjustment:[self.navigationController.navigationBar titleVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
        
        self.navigationBar.titleTextAttributes              = self.navigationController.navigationBar.titleTextAttributes;
        self.navigationBar.shadowImage                      = self.navigationController.navigationBar.shadowImage;
        self.navigationBar.backIndicatorImage               = self.navigationController.navigationBar.backIndicatorImage;
        self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController.navigationBar.backIndicatorTransitionMaskImage;
    }
    [self.view layoutIfNeeded];
}

- (UITabBarController *)tabBarController {
    UITabBarController *tabbarController = [super tabBarController];
    GKNavigationController *navigationController = self.gk_navigationController;
    if (tabbarController) {
        if (navigationController.tabBarController != tabbarController) {
            return tabbarController;
        }else {
            return !tabbarController.tabBar.isTranslucent || [navigationController.gk_viewControllers gk_any:^BOOL(__kindof UIViewController *obj) {
                return obj.hidesBottomBarWhenPushed;
            }] ? nil : tabbarController;
        }
    }
    return nil;
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    if (self.navigationController) {
        return [self.navigationController viewControllerForUnwindSegueAction:action fromViewController:self.parentViewController withSender:sender];
    }
    return [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (NSArray<UIViewController *> *)allowedChildViewControllersForUnwindingFromSource:(UIStoryboardUnwindSegueSource *)source {
    if (self.navigationController) {
        return [self.navigationController allowedChildViewControllersForUnwindingFromSource:source];
    }
    return [super allowedChildViewControllersForUnwindingFromSource:source];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    }else {
        [super pushViewController:viewController animated:animated];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.navigationController respondsToSelector:aSelector]) {
        return self.navigationController;
    }
    return nil;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.navigationController) {
        return [self.navigationController popViewControllerAnimated:animated];
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.navigationController) {
        return [self.navigationController popToViewController:viewController animated:animated];
    }
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.navigationController) {
        return [self.navigationController popToRootViewControllerAnimated:animated];
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated{
    if (self.navigationController) {
        [self.navigationController setViewControllers:viewControllers animated:animated];
    }else {
        [super setViewControllers:viewControllers animated:animated];
    }
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (self.navigationController) {
        self.navigationController.delegate = delegate;
    }else {
        [super setDelegate:delegate];
    }
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:navigationBarHidden];
}

@end

@interface GKNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<UINavigationControllerDelegate> gk_delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) id panGestureDelegate;

@end

@implementation GKNavigationController

+ (instancetype)gk_wrapNavigationControllerWithRootVC:(UIViewController *)rootVC {
    return [[self alloc] initWithRootViewController:rootVC];
}

+ (instancetype)gk_noWrapNavigationControllerWithRootVC:(UIViewController *)rootVC {
    return [[self alloc] initWithNoWrapRootViewController:rootVC];
}

#pragma mark - Private Method

- (void)backAction:(id)sender {
    [self popViewControllerAnimated:YES];
}

- (void)initialition {
    
}

- (void)setupPanGesture {
    self.panGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.panGestureDelegate action:action];
    
    self.panGesture.maximumNumberOfTouches = 1;
}

#pragma mark - Override

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.viewControllers = [super viewControllers];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialition];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    if (self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass]) {
        [self initialition];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:GKWrapViewController(rootViewController, rootViewController.gk_navigationBarClass)]) {
        [self initialition];
    }
    return self;
}

- (instancetype)initWithNoWrapRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:[[GKContainerViewController alloc] initWithContentViewController:rootViewController]]) {
        [self initialition];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super setDelegate:self];
    [super setNavigationBarHidden:YES animated:NO];
    
    [self setupPanGesture];
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    UIViewController *viewController = [super viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
    if (!viewController) {
        NSInteger index = [self.viewControllers indexOfObject:fromViewController];
        if (index != NSNotFound) {
            for (NSInteger i = index - 1; i >= 0; --i) {
                viewController = [self.viewControllers[i] viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
                if (viewController) {
                    break;
                }
            }
        }
    }
    return viewController;
}

- (void)setNavigationBarHidden:(__unused BOOL)hidden animated:(__unused BOOL)animated {}

// 重写push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIViewController *currentLastVC = GKUnWrapViewController(self.viewControllers.lastObject);
        [super pushViewController:GKWrapViewController(viewController, viewController.gk_navigationBarClass, self.useSystemBackBarButtonItem, currentLastVC.navigationItem.backBarButtonItem, currentLastVC.title) animated:animated];
    }else {
        [super pushViewController:GKWrapViewController(viewController, viewController.gk_navigationBarClass) animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return GKUnWrapViewController([super popViewControllerAnimated:animated]);
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    __block UIViewController *controllerToPop = nil;
    [[super viewControllers] enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (GKUnWrapViewController(obj) == viewController) {
            controllerToPop = obj;
            *stop           = YES;
        }
    }];
    if (controllerToPop) {
        return [[super popToViewController:controllerToPop animated:animated] gk_map:^id(__kindof UIViewController *obj, NSUInteger index) {
            return GKUnWrapViewController(obj);
        }];
    }
    return nil;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    return [[super popToRootViewControllerAnimated:animated] gk_map:^id(__kindof UIViewController *obj, NSUInteger index) {
        return GKUnWrapViewController(obj);
    }];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:[viewControllers gk_map:^id(UIViewController *obj, NSUInteger index) {
        if (self.useSystemBackBarButtonItem && index > 0) {
            return GKWrapViewController(obj, obj.gk_navigationBarClass, self.useSystemBackBarButtonItem, viewControllers[index - 1].navigationItem.backBarButtonItem, viewControllers[index - 1].title);
        }else {
            return GKWrapViewController(obj, obj.gk_navigationBarClass);
        }
    }] animated:animated];
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    self.gk_delegate = delegate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

- (nullable UIView *)rotatingHeaderView {
    return self.topViewController.rotatingHeaderView;
}

- (nullable UIView *)rotatingFooterView {
    return self.topViewController.rotatingFooterView;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }
    return [self.gk_delegate respondsToSelector:aSelector];
}

#pragma mark - Public Method

- (UIViewController *)gk_topViewController {
    return GKUnWrapViewController([super topViewController]);
}

- (UIViewController *)gk_visibleViewController {
    return GKUnWrapViewController([super visibleViewController]);
}

- (NSArray<__kindof UIViewController *> *)gk_viewControllers {
    return [[super viewControllers] gk_map:^id(__kindof UIViewController *obj, NSUInteger index) {
        return GKUnWrapViewController(obj);
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = (viewController == navigationController.viewControllers.firstObject);
    
    if (!isRootVC) {
        
        viewController = GKUnWrapViewController(viewController);
        
        if (!self.useSystemBackBarButtonItem && !viewController.navigationItem.leftBarButtonItem) {
            if ([viewController respondsToSelector:@selector(gk_customBackItemWithTarget:action:)]) {
                viewController.navigationItem.leftBarButtonItem = [viewController gk_customBackItemWithTarget:self action:@selector(backAction:)];
                
                if ([viewController isKindOfClass:[UITabBarController class]]) {
                    for (UIViewController *vc in viewController.childViewControllers) {
                        
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            for (UIViewController *subVC in vc.childViewControllers) {
                                subVC.navigationItem.leftBarButtonItem = [viewController gk_customBackItemWithTarget:self action:@selector(backAction:)];
                            }
                        }
                    }
                }
            }else {
                viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
                
                if ([viewController isKindOfClass:[UITabBarController class]]) {
                    for (UIViewController *vc in viewController.childViewControllers) {
                        
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            for (UIViewController *subVC in vc.childViewControllers) {
                                subVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
                            }
                        }
                    }
                }
            }
        }else {
            // 这里需注意，如果push了一个UITabBarController，由于上面把导航栏隐藏了，所有这里会获取不到系统的backBarButtonItem,故系统的滑动返回也会失效
            
            // 这里默认使用自定义返回按钮
            if ([viewController isKindOfClass:[UITabBarController class]]) {
                if ([viewController respondsToSelector:@selector(gk_customBackItemWithTarget:action:)]) {
                    for (UIViewController *vc in viewController.childViewControllers) {
                        
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            for (UIViewController *subVC in vc.childViewControllers) {
                                subVC.navigationItem.leftBarButtonItem = [viewController gk_customBackItemWithTarget:self action:@selector(backAction:)];
                            }
                        }
                    }
                }else {
                    for (UIViewController *vc in viewController.childViewControllers) {
                        
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            for (UIViewController *subVC in vc.childViewControllers) {
                                subVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
                            }
                        }
                    }
                }
            }
        }
    }
    
    if ([self.gk_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.gk_delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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
        self.panGesture.delegate = self;
        
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled  = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 获取当前最顶层的控制器
    UIViewController *topViewController = GKUnWrapViewController(self.viewControllers.lastObject);
    if (topViewController.gk_interactivePopDisabled) {
        return NO;
    }
    
    // 距离左边位置，全屏滑动时生效
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];

    CGFloat maxAllowedInitialDistance = topViewController.gk_popMaxAllowedDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance && !topViewController.gk_fullScreenPopDisabled) {
        return NO;
    }
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !topViewController.gk_fullScreenPopDisabled) {
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return (gestureRecognizer == self.interactivePopGestureRecognizer);
//}

@end
























