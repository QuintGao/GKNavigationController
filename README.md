## GKNavigationController --- iOS自定义导航栏-导航条联动
部分内容参考 [RTRootNavigationController](https://github.com/rickytan/RTRootNavigationController) 和 [FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

## 说明：

现在大多数的APP都有导航栏联动效果，即滑动返回的时候导航栏也跟着一起返回，比如：网易新闻，网易云音乐，腾讯视频等等，于是通过查找一些资料及其他库的做法，自己也写了一个框架，可以让每一个控制器都拥有自己的导航栏，可以很方便的改变导航栏的样式等

## 介绍：(本框架的特性)

   * 支持自定义导航栏样式（隐藏、透明等）
   * 支持控制器开关返回手势
   * 支持控制器开关全屏返回手势
   * 支持控制器设置距离左边屏幕左边的滑动区域
   * 支持动态设置导航栏透明度，可实现渐变效果
   * 完美解决UITableView，UIScrollView滑动手势冲突
   * 支持Push一个UITabBarController（有缺陷）
    
## Demo中部分截图如下：

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/001.png)

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/002.png)

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/003.png)

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/004.png)

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/005.png)

![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/006.png)

## 用法简介

1.  初始化，仍然使用系统方法

```
层次结构
1. 根控制器的导航控制器  GKNavigationController
                        - GKWrapViewController
                            - GKWrapNavigationController
                                - 你的VC1
                      ... push
                        - GKWrapViewController
                            - GKWrapNavigationController
                                - 你的VC2

2. UITabBarController作为根控制器
        UITabBarController
  、、、、、、、、、、、、          tab1
                GKNavigationController
                    - GKWrapViewController
                        - GKWrapNavigationController
                            - 你的VC1
            tab2
                GKNavigationController
                    - GKWrapViewController
                        - GKWrapNavigationController
                            - 你的VC2
            ...

```

2. 部分属性介绍
```

UIViewController:

/** 是否禁止当前控制器的滑动返回(包括全屏返回和边缘返回) */
@property (nonatomic, assign) BOOL gk_interactivePopDisabled;

/** 是否禁止当前控制器的全屏滑动返回 */
@property (nonatomic, assign) BOOL gk_fullScreenPopDisabled;

/** 全屏滑动时，滑动区域距离屏幕左边的最大位置，默认是0，表示全屏都可滑动 */
@property (nonatomic, assign) CGFloat gk_popMaxAllowedDistanceToLeftEdge;

/** 设置导航栏的透明度 */
@property (nonatomic, assign) CGFloat gk_navBarAlpha;

```

3. 关于返回Item

如果你不想用我写的返回item，你可以在当前控制器或者基类控制器中重写下面的方法：
```
- (UIBarButtonItem *)gk_customBackItemWithTarget:(id)target action:(SEL)action;

```
如果你push到的是一个UITabBarController，你需要在每个分栏的root控制器中重新定义返回按钮
```
self.navigationItem.leftBarButtonItem = ...
```

## Cocoapods(已支持)

pod 'GKNavigationController'

## 缺陷及不足
* 没有支持自定义转场，实现如：今日头条、腾讯新闻等的转场效果
* push到一个UITabBarController时需要子控制器重新自定义返回按钮
* 其他（待发现）

## 时间记录
* 2017.6.22 首次提交，发布
* 2017.6.23 部分内容修改，完善
* 2017.6.26 修复单个控制器不能设置手势返回、全屏返回、滑动区域的bug
* 2017.7.6  支持cocoapods
