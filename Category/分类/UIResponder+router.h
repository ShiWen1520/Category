//
//  UIResponder+router.h
//  Category
//
//  Created by ZSW on 2020/3/19.
//  Copyright © 2020 ZSW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (router)

/* 响应链的应用：复杂页面事件统一处理 */
/* 假设这种情况，在一个 ViewController 中有一个 TableView，在 TableView 的 cell 中有两个按钮 A 和 B，点击 A 和 B 和 Cell，都会分别在 ViewController 触发一个事件。在以前我们一般使用 delegate 或者通知的形式处理，现在我们可以试试利用 nextResponder，将所有的响应事件都传递到 ViewController 在一起处理，这样看起来不仅代码逻辑清晰，业务逻辑处理也变得简单。*/
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
