//
//  GKWrapNavigationController.h
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/23.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GKWrapNavigationController : UINavigationController

/**
 用于包装导航控制器的控制器
 */
@property (nonatomic, strong) UIViewController *gk_wrapViewContorller;

+ (instancetype)wrapNavigationControllerWithViewController:(UIViewController *)viewController;

@end
