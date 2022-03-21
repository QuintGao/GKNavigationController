//
//  AppDelegate.m
//  GKNavigationControllerDemo
//
//  Created by QuintGao on 2017/6/22.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "AppDelegate.h"
#import "GKNavigationController.h"
#import "GKMainViewController.h"
#import "AViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    GKNavigationController *navVC = [[GKNavigationController alloc] initWithRootViewController:[GKMainViewController new]];
    
//    GKNavigationController *navVC = [[GKNavigationController alloc] initWithRootViewController:[AViewController new]];
    
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
