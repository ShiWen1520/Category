//
//  NSObject+swizzle.h
//  Category
//
//  Created by ZSW on 2020/3/30.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (swizzle)

- (id)zswPerformSelector:(NSString *)aSelectorName;
- (id)zswPerformSelector:(NSString *)aSelectorName withObject:(id)object;
- (id)zswPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2;
- (BOOL)zswObserverKeyPath:(NSString *)key;

/*
IMP 函数交换通用方法
@param originalSelector 原函数
@param swizzledSelector 交换函数
*/
//实例方法
+ (void)zswSwizzledMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
//类方法
+ (void)zswSwizzledClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
