## GKNavigationController --- iOS自定义导航栏-导航条联动
部分内容参考[RTRootNavigationController](https://github.com/rickytan/RTRootNavigationController)和[https://github.com/forkingdog/FDFullscreenPopGesture]

## 说明：

    现在大多数的APP都有导航栏联动效果，即滑动返回的时候导航栏也跟着一起返回，
    比如：网易新闻，网易云音乐，腾讯视频等等，于是通过查找一些资料及其他库的做法，
    自己也写了一个框架，可以让每一个控制器都拥有自己的导航栏，可以很方便的改变导航栏的样式等

## 介绍：
   * 本框架主要有以下特性
   * 1. 支持自定义导航栏样式（隐藏、透明等）
   * 2. 支持控制器开关返回手势
   * 3. 支持控制器开关全屏返回手势
   * 4. 支持控制器设置距离左边屏幕左边的滑动区域
   * 5. 完美解决UITableView，UIScrollView滑动手势冲突
   * 6. 支持Push一个UITabBarController（有缺陷）
    
## Demo中部分截图如下：

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/001.png)

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/002.png)

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/003.png)

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/004.png)

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/005.png)

    ![image](https://github.com/QuintGao/GKNavigationController/blob/master/GKNavigationControllerDemo/006.png)
