# iOS - UIAlertController
Demo of UIAlertController
> * **Introduction:**
>  * 本文将介绍UIAlertController的相关属性及方法
>  * UIAlertAction的相关属性及方法
>  * 使用时需要注意的相关技巧
>  * 实现一些基本常用的相关功能
>* 此文章由 *@JR_Rafael* 编写. 若转载此文章，请注明出处和作者

## UIAlertController
**UIAlertController可以称之为警报控制器**，继承于UIViewController，在iOS 8.0时被提出。这个类可以替换之前的*UIActionSheet*和*UIAlertView*类来显示警报信息，之后可以通过一系列的配置来设置警报控制器的动作和你想要的风格，目前使用 *presentViewController:animated:completion: method* 来显示。

### Property：
```oc
@property (nonatomic, readonly) NSArray<UIAlertAction *> *actions; /**< 获取AlertController中的UIAlertAction对象 */

@property (nonatomic, strong, nullable) UIAlertAction *preferredAction NS_AVAILABLE_IOS(9_0); /**< 把一个AlertAction设置为醒目按钮，前提是这个Action必须在actions数组中存在 */

@property (nullable, nonatomic, copy) NSString *title; /**< 设置AlertController的标题 */
@property (nullable, nonatomic, copy) NSString *message; /**< 设置AlertController的内容 */

@property (nonatomic, readonly) UIAlertControllerStyle preferredStyle; /**< 获取AlertController的显示形式 */

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields; /**< 获取到AlertController中的UITextField对象 */

```

* 创建一个AlertController对象的方法

```oc
/**
 *  创建一个AlertController对象
 *
 *  @param title          Alert标题
 *  @param message        Alert提示信息
 *  @param preferredStyle Alert的样式
 *
 *  @return AlertController对象
 */
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;
```

```oc

/** 创建一个UIAlertController */
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"UIAlertController Alert样式" preferredStyle:UIAlertControllerStyleAlert];

/** 显示UIAlertController */
[self presentViewController:alert animated:YES completion:^{}];

```
***
以上方法显示出来的效果与UIAlertView效果一致，如果要显示出UIActionSheet效果，可以修改preferredStyle参数：

```oc

typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
    UIAlertControllerStyleActionSheet = 0, // ActionSheet样式
    UIAlertControllerStyleAlert            // Alert样式
} NS_ENUM_AVAILABLE_IOS(8_0);

```
## UIAlertAction
除了向用户显示一条消息，警报控制器还可以通过addAction:方法为用户提供一系列的响应事件。所以UIAlertController的使用还需要另外一个重要的类：**UIAlertAction**。

* 创建一个UIAlertAction对象的方法

```oc
/**
 *  创建一个AlertAction对象
 *
 *  @param title   Action标题
 *  @param style   Action样式(三种)
 *  @param handler Action点击block
 *
 *  @return AlertAction的一个对象
 */
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;
```

```oc
// FIXME: 默认样式
UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
// TODO: 给Alert添加按钮
[alert addAction:action0];
```
相对应的点击后出发的事件在block中实现。
***

### UIAlertActionStyle

UIAlertAction给我们提供了三种形式的按钮：

```oc

typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
    UIAlertActionStyleDefault = 0,  // 默认按钮
    UIAlertActionStyleCancel,       // 取消按钮
    UIAlertActionStyleDestructive   // 重置按钮
} NS_ENUM_AVAILABLE_IOS(8_0);

```
> * **UIAlertActionStyleDefault**
> 默认按钮，可以添加很多个，也可以对应实现不同的触发事件。
> * **UIAlertActionStyleCancel** 一个UIAlertController里面只能存在至多一个取消按钮，如果添加多个系统会报出错误信息
> 
>  ```oc
 reason: 'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
 ```
> * **UIAlertActionStyleDestructive** 重置按钮，可以添加多个，也可以实现不同的出发事件，UI效果为红色按钮，通常情况下用于对数据进行更改或者删除操作，红色醒目，提醒用户。

### Property：
UIAlertAction的相关属性：

```oc
@property (nullable, nonatomic, readonly) NSString *title; /**< 设置AlertAction的标题 */
@property (nonatomic, readonly) UIAlertActionStyle style; /**< 获取AlertAction的形式 */
@property (nonatomic, getter=isEnabled) BOOL enabled; /**< 按钮是否可以点击 */
```
***
### 为AlertController添加文本框(UITextField)
有很多情况下为UIAlertController添加按钮去触发相应的响应事件是不够的，还需要添加UITextField。而UIAlertController有一个类方法可以实现这一功能：

```oc
/**
 *  为UIAlertController添加UITextField
 *
 *  @param configurationHandler 对textField进行处理
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;
```
通过类方法在AlertController上添加textField，通过点击AlertController上的AlertAction相应对应的事件。
***
如果在一个AlertController上添加多个UITextField，可以通过AlertController的一个属性去获取到textField的数组，通过添加顺序找到对应的对象。
> @property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;  // 获取到AlertController中的UITextField对象

可以为block中的textField设置代理，从而实现协议方法，不过要在block中获取到当前类的对象不可以直接使用*self*，需要在方法的外部获取到当前类对象的指针地址，并且用__block修饰才可以在block内部设置代理人。具体代码：

```oc
    __block ViewController *vc = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
        textField.delegate = vc;
        [[NSNotificationCenter defaultCenter] addObserver:vc
                                                 selector:@selector(alertTextFieldDidChange:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:textField];
    }];
```

以上方法除了设置代理外，也使用了通知中心，通过通知中心去实现一个方法，其作用是：当textField的text属性字符串长度超过3的时候，AlertAction才能够点击：

```oc
/**
 *  监听textField的改变状况
 *
 *  @param notification UITextFieldTextDidChangeNotification
 */
- (void)alertTextFieldDidChange:(NSNotification *)notification {
    // FIXME: 输入三个字符以上才允许点击
    UITextField *nameField = _AlertVc.textFields[2];
    UIAlertAction *nameAction = _AlertVc.actions[0];
    nameAction.enabled = nameField.text.length > 2;
}
```
***

[TOC]

**本文介绍到这里，具体内容请下载相关Demo**

### 作者联系方式：
> * Email1：JR_Rafael@163.com
> * Email2：rafeal_mac@me.com

### GitHub address: https://github.com/JRRafaels/JR_Demo_UIAlertController.git

