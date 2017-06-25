//
//  GKDemo004ViewController.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/22.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKDemo005ViewController.h"
#import "GKNavigationController.h"
#import "GKDemo001ViewController.h"
#import "GKDemo002ViewController.h"
#import "GKDemo003ViewController.h"

@interface GKDemo005ViewController ()

@end

@implementation GKDemo005ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor redColor];
    
    [self addChildVC:[GKDemo001ViewController new] title:@"首页" imageName:@"Home"];
    [self addChildVC:[GKDemo002ViewController new] title:@"活动" imageName:@"Activity"];
    [self addChildVC:[GKDemo003ViewController new] title:@"我的" imageName:@"Mine"];
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title imageName:(NSString *)name {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:name];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", name]];
        
    GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end
