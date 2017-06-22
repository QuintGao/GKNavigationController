//
//  NSArray+Category.h
//  GKNavigationController
//
//  Created by QuintGao on 2017/6/20.
//  Copyright © 2017年 高坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<ObjectType> (GKCategory)

- (NSArray *)gk_map:(id(^)(ObjectType obj, NSUInteger index))block;

- (BOOL)gk_any:(BOOL(^)(ObjectType obj))block;

@end
