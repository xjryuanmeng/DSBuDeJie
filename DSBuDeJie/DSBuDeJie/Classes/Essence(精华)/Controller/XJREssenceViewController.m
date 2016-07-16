//
//  XJREssenceViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJREssenceViewController.h"

@interface XJREssenceViewController ()

@end

@implementation XJREssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    //设置导航条的内容
    [self setupNavBar];
}
//设置导航条的内容
-(void)setupNavBar{
    //左边
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] addTarget:self action:@selector(game)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] addTarget:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
-(void)game{
    XJRLog(@"点击了此按钮");
}
@end
