//
//  XJRFastLoginButton.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRFastLoginButton.h"

@implementation XJRFastLoginButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.xjr_centerX = self.xjr_width * 0.5;
    self.imageView.xjr_y = 0;
    
    // 根据文字内容计算下label,设置好label尺寸
    [self.titleLabel sizeToFit];
    self.titleLabel.xjr_centerX = self.xjr_width * 0.5;
    self.titleLabel.xjr_y = self.xjr_height - self.titleLabel.xjr_height;
    
    // 文字显示不出来:label尺寸不够 -> label跟文字一样
    // label宽度 => 计算文字宽度
}

@end
