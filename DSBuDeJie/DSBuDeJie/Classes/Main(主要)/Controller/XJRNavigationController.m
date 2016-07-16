//
//  XJRNavigationController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRNavigationController.h"

@interface XJRNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation XJRNavigationController
+(void)load{
    //获取全局导航条
    //只要遵守了UIAppearance,就可以调用appearance 获取全局外观
    //UINavigationBar *navBar = [UINavigationBar appearance];
    
    //获取当前类下的导航条
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    //设置标题字体
    //设置导航条标题字体 => 拿到导航条去设置
    //[UINavigationBar appearance];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    navBar.titleTextAttributes = attr;
    //设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
//全屏滑动: 分析:为什么导航控制器的滑动手势只能边缘滑动
/*
 UIScreenEdgePanGestureRecognizer
     滑动手势
 
 触发UIScreenEdgePanGestureRecognizer就会有滑动返回功能
 触发UIScreenEdgePanGestureRecognizer就会调用它的target的action方法
 UIScreenEdgePanGestureRecognizer的target的action=>滑动返回功能
 
 <UIScreenEdgePanGestureRecognizer: 0x7fb353ec2830; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fb353ec1040>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fb353ec2710>)>>
 */
//target=<_UINavigationInteractiveTransition 0x7fb353ec2710>
//<_UINavigationInteractiveTransition: 0x7f9f28549540> 滑动手势代理(验证有无代理)
- (void)viewDidLoad {
    [super viewDidLoad];
    //滑动功能
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    //控制器手势什么时候触发
    pan.delegate = self;
    //Bug:假死状态,程序一直在跑,但是界面死了
    //在跟控制器下,滑动返回,不应该在跟控制器的view上滑动返回
    
    //清空手势代理,恢复滑动返回按钮
    //self.interactivePopGestureRecognizer.delegate = nil;
    //-->控制手势何时失效,解决Bug,自己成为手势的代理
    self.interactivePopGestureRecognizer.enabled = NO;
    //self.interactivePopGestureRecognizer.delegate = self;

    //验证有无代理
    //NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
}
#pragma mark -UIGestureRecognizerDelegate
//是否触发手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //在跟控制下 不要 触发手势
    return self.childViewControllers.count > 1 ;
}
//执行跳转操作方法push
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //导航控制器默认有一个滑动返回功能(导航控制器才有返回功能)
    //把系统的返回按钮覆盖,就没有滑动返回功能-->
    //滑动返回功能为什么失效:用了滑动手势去做,验证滑动手势在不在(pass)
    //代理可以控制手势是否失效,验证代理做了一些事情,导致滑动手势失效
    if (self.childViewControllers.count > 0) {//非跟控制器
        
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        //非根控制器才需设置返回按钮
        //设置返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        //设置文字颜色
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //点击按钮做事情
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backButton sizeToFit];
        //注意:一定要在按钮内容有尺寸的时候,设置才有效
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        //设置滑动返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        //验证滑动手势在不在
        //NSLog(@"%@",self.interactivePopGestureRecognizer);

    }
    
    //这个方法才是真正执行跳转
    [super pushViewController:viewController animated:YES];
}
//点击返回按钮做事情
-(void)back {
    //返回上一个控制器
    [self popViewControllerAnimated:YES];
}
@end
