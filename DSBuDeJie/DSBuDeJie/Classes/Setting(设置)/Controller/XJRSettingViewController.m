//
//  XJRSettingViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRSettingViewController.h"

@interface XJRSettingViewController ()

@end

@implementation XJRSettingViewController
// 整个应用程序下所有的返回按钮都一样 -> 如何统一设置返回按钮(每次push都需要设置返回按钮)
- (void)viewDidLoad {
    [super viewDidLoad];
    // 通过这个方式去设置导航标题
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:UIBarButtonItemStyleDone target:self action:@selector(jump)];
}
- (void)jump
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击返回按钮做事情(此处只能单独设置自己的返回按钮,而不能设置全局的,因此将此处代码移植到导航控制器中)
//-(void)back {
//    //返回上一个控制器
//    [self.navigationController popViewControllerAnimated:YES];
//}
@end
