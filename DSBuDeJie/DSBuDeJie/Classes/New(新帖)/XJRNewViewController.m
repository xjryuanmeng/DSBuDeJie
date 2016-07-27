//
//  XJRNewViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRNewViewController.h"
#import "XJRSubTagViewController.h"

@interface XJRNewViewController ()

@end

@implementation XJRNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    //self.view.backgroundColor = [UIColor blueColor];
    //设置导航条的内容
    [self setupNavBar];
}
//设置导航条的内容
-(void)setupNavBar{
    //左边
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] addTarget:self action:@selector(subTag)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
//点击了订阅标签
-(void)subTag{
    //XJRLog(@"点击了订阅");
    //创建订阅标签控制器
    XJRSubTagViewController *subTagVc = [[XJRSubTagViewController alloc]init];
    //跳转到订阅标签控制器
    [self.navigationController pushViewController:subTagVc animated:YES];
}
@end
