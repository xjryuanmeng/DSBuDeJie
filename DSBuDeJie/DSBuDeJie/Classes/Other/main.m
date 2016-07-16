//
//  main.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
// main程序入口
// UIApplicationMain
// 1.创建UIApplication对象 (1.打电话发短信,打开网页 2.设置应用程序提醒数字 3.设置联网状态 4.控制状态栏)
// 2.创建UIApplication代理对象(1.监听整个应用程序的生命周期 2.处理内存警告,清空图片缓存)
// 3.开启主运行循环,保证程序一直运行,runloop(重要),每一个线程都有runloop,主线程的runloop自动开启,其他线程需要手动管理
// 4.加载info.plist文件,判断下是否指定了main,如果指定就会去加载
/*
 加载main.storyboard
 1.创建窗口
 2.创建窗口的根控制器
 3.显示窗口
 */
int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
