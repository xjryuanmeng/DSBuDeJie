//
//  XJRFriendTrendViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRFriendTrendViewController.h"
#import "XJRLoginRegisterViewController.h"

@interface XJRFriendTrendViewController ()

@end
/*
 UITabBarItem:决定tabBar上按钮的内容
 UINavigationItem:决定导航条上内容,左边,右边,中间有内容
 UIBarButtonItem:决定导航条上按钮具体内容
 */
@implementation XJRFriendTrendViewController
//进入到登录注册界面
- (IBAction)loginRegister {
    //创建登录注册控制器
    XJRLoginRegisterViewController *loginVc = [[XJRLoginRegisterViewController alloc]init];
    //modal
    [self presentViewController:loginVc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor greenColor];
    //设置导航条的内容
    [self setupNavBar];
}
//设置导航条的内容
-(void)setupNavBar{
    //左边
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] addTarget:self action:@selector(friendsRecomment)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.title = @"我的关注";
    //设置标题字体
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    self.navigationController.navigationBar.titleTextAttributes = attr;
}
-(void)friendsRecomment{
    XJRLog(@"我的关注");
}
@end
