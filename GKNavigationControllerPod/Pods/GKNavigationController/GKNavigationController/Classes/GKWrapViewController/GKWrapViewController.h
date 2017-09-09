//
//  GKWrapViewController.h
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//
/* 说明：此类是用来将传入的UIViewController 包装一个导航控制器（GKWrapNavigationController),然后再包装一个
    UIViewController(GKWrapViewController),并将包装后的控制器返回
*/

#import <UIKit/UIKit.h>

@interface GKWrapViewController : UIViewController

/**
 这里用来记录包装前的控制器
 */
@property (nonatomic, strong, readonly) __kindof UIViewController *contentViewController;

/**
 包装控制器的方法

 @param viewController 将要包装的控制器
 @return 包装后的控制器
 */
+ (instancetype)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end
