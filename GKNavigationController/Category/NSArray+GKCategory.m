//
//  NSArray+Category.m
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import "NSArray+GKCategory.h"

@implementation NSArray (GKCategory)
- (NSArray *)gk_map:(id (^)(id, NSUInteger))block {
    if (!block) {
        block = ^(id obj, NSUInteger index) {
            return obj;
        };
    }
    NSMutableArray *array = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:block(obj, idx)];
    }];
    return [NSArray arrayWithArray:array];
}

- (BOOL)gk_any:(BOOL (^)(id))block {
    if (!block) return NO;
    
    __block BOOL result = NO;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            result = YES;
            *stop  = YES;
        }
    }];
    return result;
}

@end
