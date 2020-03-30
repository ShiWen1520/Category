//
//  NSObject+swizzle.m
//  Category
//
//  Created by ZSW on 2020/3/30.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "NSObject+swizzle.h"

@implementation NSObject (swizzle)

/*
 SEL:类成员方法的指针,没有保存方法的地址,只是方法编号
 IMP:函数指针,直接保存了方法的地址
 */
- (id)zswPerformSelector:(NSString *)aSelectorName {
    if(aSelectorName == nil || aSelectorName.length < 1) return nil;
    
    //通过方法获取方法编号
    SEL sel = NSSelectorFromString(aSelectorName);
    
    if (sel && [self respondsToSelector:sel]) {
        //通过方法编号获取到IMP(方法的地址)
        IMP imp = [self methodForSelector:sel];
        //执行IMP
        id (*func)(id, SEL) = (void *)imp;
        return func(self, sel);
    }
    return nil;
}

- (id)zswPerformSelector:(NSString *)aSelectorName withObject:(id)object {
    if(aSelectorName == nil || aSelectorName.length < 1) return nil;
    
    //通过方法获取方法编号
    SEL sel = NSSelectorFromString(aSelectorName);
    
    if (sel && [self respondsToSelector:sel]) {
        //通过方法编号获取到IMP(方法的地址)
        IMP imp = [self methodForSelector:sel];
        //执行IMP
        id (*func)(id, SEL, id anObject) = (void *)imp;
        return func(self, sel, object);
    }
    return nil;
}

- (id)zswPerformSelector:(NSString *)aSelectorName withObject:(id)object1 withObject:(id)object2 {
    if(aSelectorName == nil || aSelectorName.length < 1) return nil;
    
    //通过方法获取方法编号
    SEL sel = NSSelectorFromString(aSelectorName);
    
    if (sel && [self respondsToSelector:sel]) {
        //通过方法编号获取到IMP(方法的地址)
        IMP imp = [self methodForSelector:sel];
        //执行IMP
        id (*func)(id, SEL, id anObject, id anObject1) = (void *)imp;
        return func(self, sel, object1, object2);
    }
    return nil;
}

- (BOOL)zswObserverKeyPath:(NSString *)key {
    if(key == nil || key.length < 1) return nil;
    
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for(id objc in array) {
        id properties = [objc valueForKey:@"_property"];
        NSString *keyPath = [properties valueForKey:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}

/* IMP交换 */

//实例方法
+ (void)zswSwizzledMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    if (!originalSelector || !swizzledSelector) return;
    
    Class class = [self class];
    //原来的方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //交换的方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试为源SEL添加IMP,为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) { //添加成功:如果源SEL没有实现IMP,将源SEL的IMP替换到交换的SEL的IMP
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else { //添加失败:如果源SEL已经实现了IMP,直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//类方法
+ (void)zswSwizzledClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    if (!originalSelector || !swizzledSelector) return;
    
    Class class = [self class];
    //原来的方法
    Method originalMethod = class_getClassMethod(class, originalSelector);
    //交换的方法
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    //先尝试为源SEL添加IMP,为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) { //添加成功:如果源SEL没有实现IMP,将源SEL的IMP替换到交换SEL的IMP
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }else { //添加失败:如果源SEL已经实现了IMP,直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
