//
//  XJRTabBar.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/3.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRTabBar.h"

@interface XJRTabBar ()
//添加发布按钮
@property(nonatomic, weak) UIButton *plusButton;
@end

@implementation XJRTabBar
//创建一次,采用懒加载
-(UIButton *)plusButton{
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置内容
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        //设置尺寸
        //根据自己内容(图片,标题)去计算尺寸
        [btn sizeToFit];
        _plusButton = btn;
        [self addSubview:btn];
    }
    return _plusButton;
}
/*
 发现系统有这个类,但是就是敲不出来,说明这个类 私有API
 私有API : 只能苹果使用, 你使用不了
 */
//布局子控件
-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.items.count + 1;
    //调整内部子控件的位置
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.xjr_width/ count;
    CGFloat btnH = self.xjr_height;
    int i = 0;
    //拿到子控件-->遍历子控件
    for (UIView * tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i += 1;
            }
            btnX = i * btnW;
            // 此处为 UITabBarButton
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            i++;
        }
    }
    //设置加号(发布)按钮居中
    self.plusButton.center = CGPointMake(self.xjr_width *  0.5, self.xjr_height * 0.5);
}
@end
