//
//  XJRLoginRegisterViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRLoginRegisterViewController.h"
#import "XJRLoginRegisterView.h"
#import "XJRFastLoginView.h"

/*
 自定义view:以后只要看到比较复杂界面
 */
@interface XJRLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation XJRLoginRegisterViewController
//点击关闭
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击注册按钮
- (IBAction)clickRegister:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    //移动中间的view
    _leadCons.constant =  _leadCons.constant==0? -XJRScreenW : 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/*
 1.划分下整个界面结构(3块)
 2.一个一个结构做
 */

/*
 1.如果一个控件从xib加载,必须固定尺寸
 2.在viewDidLoad设置子控件位置(不准,因为约束还没有执行,因此不在这里设置pass)
   在viewDidLayoutSubviews布局子控件
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加登录view
    // 默认一个view从xib加载,尺寸跟xib一样
    XJRLoginRegisterView *loginView = [XJRLoginRegisterView loginView];
    [self.middleView addSubview:loginView];
    // 添加注册view
    XJRLoginRegisterView *registerView = [XJRLoginRegisterView registerView];
    //registerView.xjr_x = self.middleView.xjr_width * 0.5;
    [self.middleView addSubview:registerView];
    // 添加快速登录view
    XJRFastLoginView *fastView = [XJRFastLoginView fastLoginView];
    [self.bottomView addSubview:fastView];

}
// 执行约束,里面尺寸才是最准确.
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // 设置登录
    XJRLoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.xjr_width * 0.5, self.middleView.xjr_height);
    // 设置注册
    XJRLoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.xjr_width * 0.5, 0, self.middleView.xjr_width * 0.5, self.middleView.xjr_height);
    // 设置快速登录view
    XJRFastLoginView *fastView = self.bottomView.subviews[0];
    fastView.frame = self.bottomView.bounds;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
