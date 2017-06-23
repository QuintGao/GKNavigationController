//
//  GKMainViewController.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/22.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "GKMainViewController.h"
#import "GKDemo001ViewController.h"
#import "GKDemo002ViewController.h"
#import "GKDemo003ViewController.h"
#import "GKDemo004ViewController.h"
#import "GKDemo005ViewController.h"
#import "GKDemo006ViewController.h"
#import "GKNavigationController.h"

@interface GKMainViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GKMainViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"push一个变色导航栏控制器",
                        @"push一个透明导航栏控制器",
                        @"push一个无导航栏控制器",
                        @"push一个UITabBarController",
                        @"present一个UITabBarController",
                        @"push一个UITableView",
                        @"push一个UIScrollView"
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    self.title = @"Main";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = [[NSString alloc] initWithFormat:@"GKDemo00%zdViewController", indexPath.row + 1];
    
    Class class = NSClassFromString(className);
    
    UIViewController *vc = [[class alloc] init];
    
    if (indexPath.row == 4) {
        
//        GKNavigationController *nav = [[GKNavigationController alloc] initWithRootViewController:vc];
//        nav.useSystemBackBarButtonItem = YES;
        
//        [self presentViewController:nav animated:YES completion:nil];
        [self presentViewController:vc animated:YES completion:nil];
        
        return;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
