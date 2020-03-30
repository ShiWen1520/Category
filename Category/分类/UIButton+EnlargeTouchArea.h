//
//  UIButton+EnlargeTouchArea.h
//  Category
//
//  Created by ZSW on 2020/3/19.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EnlargeTouchArea)

/* 响应链的应用：扩大响应范围 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
