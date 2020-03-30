//
//  UIResponder+router.m
//  Category
//
//  Created by ZSW on 2020/3/19.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import "UIResponder+router.h"

@implementation UIResponder (router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
