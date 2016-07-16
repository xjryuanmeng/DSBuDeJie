//
//  UIBarButtonItem+XJRItem.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "UIBarButtonItem+XJRItem.h"

@implementation UIBarButtonItem (XJRItem)
+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage addTarget:(id)target action:(SEL)action{
    //包装一个UIButton,实现图片显示两种状态
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    //设置尺寸
    [btn sizeToFit];
    //btn.backgroundColor = [UIColor blueColor];
    //监听按钮的点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 解决导航条按钮 点击范围过大的问题
    UIView *btnView = [[UIView alloc]initWithFrame:btn.bounds];
    [btnView addSubview:btn];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btnView];
}
+(UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage addTarget:(id)target action:(SEL)action{
    //包装一个UIButton,实现图片显示两种状态
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    //设置尺寸
    [btn sizeToFit];
    //btn.backgroundColor = [UIColor blueColor];
    //监听按钮的点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 解决导航条按钮 点击范围过大的问题
    UIView *btnView = [[UIView alloc]initWithFrame:btn.bounds];
    [btnView addSubview:btn];
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btnView];
}
@end
