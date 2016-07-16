//
//  XJMeRTableViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJMeRTableViewController.h"
#import "XJRSettingViewController.h"
// 按钮选中状态 必须 手动设置
@interface XJMeRTableViewController ()

@end

@implementation XJMeRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    //设置导航条的内容
    [self setupNavBar];
}
//设置导航条的内容
-(void)setupNavBar{
    //右边边
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] addTarget:self action:@selector(setting)];
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] addTarget:self action:@selector(night:)];
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.title = @"我的";
}
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
    
}
//点击设置按钮就会调用
- (void)setting
{
    /*
     问题:
     1.底部条没有隐藏
     2.返回按钮样式
     */
    
    //设置界面有自己的业务逻辑,因此要自定义,方便自己的事情自己管理,方便以后精确查找,修改
    XJRSettingViewController *settingVc = [[XJRSettingViewController alloc]init];
    //一定要注意在Push之前去设置这个属性(Push谁就拿到谁去设置这个属性)
    settingVc.hidesBottomBarWhenPushed = YES;
    //跳转到设置界面
    [self.navigationController pushViewController:settingVc animated:YES];
}
@end
