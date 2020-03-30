//
//  NSObject+forwarding.m
//  动态方法解析和消息转发
//
//  Created by ZSW on 2020/3/28.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "NSObject+forwarding.h"
#import <objc/runtime.h>

@implementation NSObject (forwarding)

/*
  Category is implementing a method which will also be implemented by its primary class  这个警告的意思是 我在category中重写了原类的方法 而苹果的官方文档中明确表示  我们不应该在category中复写原类的方法，如果要重写 请使用继承
 */

/*
  忽略警告解决方法:
 
 第一步:
  #pragma clang diagnostic push
  #pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
  
  //override
 
  #pragma clang diagnostic pop
 
 第二步:
 在target的 build settings下  搜索other warning flags  然后给其添加 -Wno-objc-protocol-method-implementation
 
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        return [self methodSignatureForSelector:aSelector];
    }
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

///* 降低unrecognize selector奔溃率 : 可以在这里将log上传至服务器 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    NSLog(@"对象:%@找不到%@方法", [anInvocation.target class], NSStringFromSelector(anInvocation.selector));
    
}

#pragma clang diagnostic pop


@end
