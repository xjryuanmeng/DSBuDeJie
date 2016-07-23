//
//  XJRTitleButton.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/23.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRTitleButton.h"

@implementation XJRTitleButton

/*
 Designated initializer : 特定构造方法(方法声明后面带有NS_DESIGNATED_INITIALIZER)
 
 Designated initializer missing a 'super' call to a designated initializer of the super class
 
 注意:子类如果重写了父类的特定构造方法, 那么必须使用super调用父类的特定构造方法
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        // 文字颜色
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        //随机色
        self.titleLabel.backgroundColor = XJRRandomColor;
    }
    return self;
}

- (instancetype)abc
{
    return self;
}

/**
 *  不让按钮达到高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted {}
@end
