//
//  XJRTabBarController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRTabBarController.h"
#import "XJREssenceViewController.h"
#import "XJRNewViewController.h"
#import "XJRPublishViewController.h"
#import "XJRFriendTrendViewController.h"
#import "XJMeRTableViewController.h"
#import "UIImage+XJRRender.h"
#import "XJRTabBar.h"
#import "XJRNavigationController.h"
// 分类思想:复用,以后其他项目有同样功能,直接拖过去用
// 改插件 -> 查找插件 -> 插件怎么安装 -> 打开插件代码 -> 搜索 plug -> 安装路径
// 搭建界面 -> 展示内容 -> 调整细节
/*
 tabBar问题:
 1.图片被渲染  选中按钮 图片不被渲染 1.修改图片 2.通过代码
 TODO:
 功能:没有图片提示功能 -> 修改插件
2.选中文字不需要渲染 -> 当按钮被选中的时候,文字颜色不要渲染 -> 文字也属于按钮内容 -> 找对应的子控制器的tabBarItem
 3.发布按钮 显示不出来
 分析: 发布按钮为何不能显示 -->发布按钮图片比较大,显示出来就有问题(修改图片大小,pass不行)
 -->让正常状态下的图片不被渲染,图片显示出来
 图片位置:
 UITabBarItem: 不是一个按钮,只是系统给你提供的按钮的对应模型
 最终解决方案:不能直接使用系统的UITabBarItem, 因为我们想要的效果 高亮
 系统TabBarItem对应按钮 只有选中状态
 1.自定义TabBar:继承UITabBar:修改tabBar内部子控件位置
 2.把系统tabBarVc的tabBar换成自己tabBar
 3.重写layoutSubviews
 思考在哪写代码 -> 设置多少次 -> 一次 -> viewDidLoad:控制器
 */
@interface XJRTabBarController ()

@end

@implementation XJRTabBarController
//在此获取全局tabBarItem
+(void)load{
    //获取全局的tabBarItem
    //UITabBarItem *item = [UITabBarItem appearance];
    
    //获取当前类的tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    //设置选中文字颜色
    //创建字典去描述文本
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    //文本颜色-->描述富文本属性的key--> NSAttributedString.h
    attr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
    //设置字体(改变字体大小)
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:attrnor forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //添加所有子控制器
    [self setupAllChildViewController];
    //设置tabBar上对应按钮的内容 -->由对应自控制器的 tabBarItem 决定
    [self setupAllTitleButton];
    //自定义TabBar
    [self setupTabBar];
    //XJRFunc;
    //XJRLog(@"%s",__func__);
    }
#pragma mark - 添加所有子控制器
-(void)setupAllChildViewController{
    //精华
    XJREssenceViewController * essenceVc = [[XJREssenceViewController alloc]init];
    // initWithRootViewController -> push
    // 导航控制器会把栈顶控制器的view添加到上去
    XJRNavigationController *nav = [[XJRNavigationController alloc]initWithRootViewController:essenceVc];
    [self addChildViewController:nav];
    //新帖
    XJRNewViewController * newVc = [[XJRNewViewController alloc]init];
    XJRNavigationController *nav1 = [[XJRNavigationController alloc]initWithRootViewController:newVc];
    [self addChildViewController:nav1];
    //发布
    //XJRPublishViewController * publishVc = [[XJRPublishViewController alloc]init];
    //[self addChildViewController:publishVc];
    //关注
    XJRFriendTrendViewController * friendTrendVc = [[XJRFriendTrendViewController alloc]init];
    XJRNavigationController *nav3 = [[XJRNavigationController alloc]initWithRootViewController:friendTrendVc];
    [self addChildViewController:nav3];
    //我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XJMeRTableViewController" bundle:nil];
    XJMeRTableViewController * meVc = [storyboard instantiateInitialViewController];
    //XJMeRTableViewController * meVc = [[XJMeRTableViewController alloc]init];
    XJRNavigationController *nav4 = [[XJRNavigationController alloc]initWithRootViewController:meVc];
    [self addChildViewController:nav4];
}
#pragma mark - 设置tabBar上对应按钮的内容
-(void)setupAllTitleButton{
    //0:精华
    UINavigationController *nav =self.childViewControllers[0];
    //标题
    nav.tabBarItem.title = @"精华";
    //图片
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    //选中
    nav.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabBar_essence_click_icon"];
    //1:新帖
    UINavigationController *nav1 =self.childViewControllers[1];
    //标题
    nav1.tabBarItem.title = @"新帖";
    //图片
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    //选中
    nav1.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabBar_new_click_icon"];
    //2:发布
    //XJRPublishViewController *publish =self.childViewControllers[2];
    //标题
    //publish.tabBarItem.title = @"发布";
    //图片
    //publish.tabBarItem.image = [UIImage imageNameWithOriginal:@"tabBar_publish_icon"];
    //设置图片位置
    //publish.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //选中
    //publish.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabBar_publish_click_icon"];
    //3:关注
    UINavigationController *nav3 =self.childViewControllers[2];
    //标题
    nav3.tabBarItem.title = @"关注";
    //图片
    nav3.tabBarItem.image = [UIImage imageNameWithOriginal:@"tabBar_friendTrends_icon"];
    //选中
    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
    //4:我
    UINavigationController *nav4 =self.childViewControllers[3];
    //标题
    nav4.tabBarItem.title = @"我";
    //图片
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    //选中
    nav4.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabBar_me_click_icon"];
}
#pragma mark - 自定义TabBar
-(void)setupTabBar{
    XJRTabBar *tabBar = [[XJRTabBar alloc]init];
    //替换系统的TabBar KVC:设置readonly属性
    [self setValue:tabBar forKey:@"tabBar"];
    //KVC 的底层实现
    /*
     1.查找有没有set方法
     2.查找有没有tabBar
     3.查找有没有_tabBar
     */
}
@end
