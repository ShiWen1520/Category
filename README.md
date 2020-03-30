

**目的:** 常用分类的收集,写在这里,以便后续的使用,提高开发效率;后续会继续更新使用到的分类,有好用的分类这边没有涉及到的,可以@我,一起分享!另外,若有错误的地方,请指正。

### NSObject+forwarding

##### 消息转发机制的应用

消息转发机制这里不多说了,参考这里[iOS Runtime 消息转发机制原理和实际用途](https://www.jianshu.com/p/fdd8f5225f0c);

##### 作用

为了降低unrecognize selector奔溃率,可以用这个分类处理方法找不到的异常错误,首先重写- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
方法,若找不到方法实现,返回一个方法签名,之后会调用- (void)forwardInvocation:(NSInvocation *)anInvocation方法,可以在这里将log信息上传至服务器,既避免了奔溃,
又可以在后台查看是哪个对象调用方法报错的信息。具体的实现可以在代码里查看。

### UIResponder+router

##### 响应链的应用

复杂页面事件统一处理

##### 场景和作用

假设这种情况，在一个 ViewController 中有一个 TableView，在 TableView 的 cell 中有两个按钮 A 和 B，点击 A 和 B 和 Cell，都会分别在 ViewController 触发一个事件。在以前我们一般使用 delegate 或者通知的形式处理，现在我们可以试试利用 nextResponder，将所有的响应事件都传递到 ViewController 在一起处理,
，这样看起来不仅代码逻辑清晰，业务逻辑处理也变得简单。具体的实现可以在代码里查看。

### UIButton+EnlargeTouchArea

##### 响应链的应用

扩大响应范围

##### 作用

通过重写- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event方法实现扩大button的响应范围。

### NSObject+swizzle

##### runtime机制的应用

方法交换的实现

##### 作用

所有继承自NSObject的类都可以使用 IMP 函数交换通用方法，简单的实现自定义的方法。

### NSString+SWExtention

##### 作用

这里定义了一些NSString的通用方法，具体看代码实现。



参考:[https://github.com/ZXLBoaConstrictor/ZXLBaseLibrary/tree/master/ZXLBaseLibrary/Classes/Extension](https://github.com/ZXLBoaConstrictor/ZXLBaseLibrary/tree/master/ZXLBaseLibrary/Classes/Extension)
