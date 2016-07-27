//
//  AppDelegate.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "AppDelegate.h"
#import "XJRTabBarController.h"
#import "XJRADViewController.h"

// 架构思想 MVC  MVVM MVCS VIPER:美团

// 自定义类 -> 先看下有没有划分项目结构

// 自定义类 -> 谁的事情谁管理 -> 方便以后修改需求,顺序找到对应的类做事情

/*
 每次程序启动的时候-->进入广告界面
 
 广告界面怎么去做? --->
 1.在程序启动的时候展示广告界面(pass)
 2.在程序启动完成的时候,再进入广告界面
      1.在窗口上 添加广告界面
      2.搞一个广告控制器,直接设置为窗口的跟控制器
 
 产品经理:欺骗用户,让用户一直感觉在启动程序,瞬间插入广告
 用户不介意
 
 */
@interface AppDelegate ()
@property (nonatomic, strong) UIWindow *topWindow;
@end

@implementation AppDelegate
// 如何判断UITabBarController里面有多少个子控制器,看下tabBar中有多少个按钮
/**
 *  可以在这个AppDelegate方法中监听到状态栏的点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject locationInView:nil].y > 20) return;
    
    XJRLog(@"点击了状态栏");
}
// 程序启动的时候调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //进入广告界面
    
    
    //1.创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 2.创建窗口的根控制器 => 一开始想显示什么效果
    
    // UITabBarController:会把第0个子控制器的view添加上去
    // UITabBarController点击下面的按钮,就会把对应子控制器view添加上去,移除上一个子控制器view
    //XJRTabBarController * tabBarVc = [[XJRTabBarController alloc]init];
    //self.window.rootViewController = tabBarVc;
    
    //创建广告界面,展示启动界面
    XJRADViewController *adVc = [[XJRADViewController alloc]init];
    self.window.rootViewController = adVc;

    //添加子控制器--->(移植自定义控制器中)
    // 3.显示窗口 makeKey:UIApplication主窗口
    // 窗口会把根控制器的view添加到窗口
    [self.window makeKeyAndVisible];
    //购物车(红色浮动方块)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            // UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
            // 级别越高的window越显示在上面
            // 级别相等的window,后面显示的window显示在上面
    
            self.topWindow = [[UIWindow alloc] init];
            // self.topWindow.frame = application.statusBarFrame;
            self.topWindow.frame = CGRectMake(280, 500, 80, 80);
            self.topWindow.backgroundColor = [UIColor redColor];
            self.topWindow.windowLevel = UIWindowLevelAlert;
            self.topWindow.hidden = NO;
            [self.topWindow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)]];
    });
    return YES;
}

- (void)click
{
    XJRFunc;
}
@end
