//
//  UIView+XJRFrame.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/3.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "UIView+XJRFrame.h"

@implementation UIView (XJRFrame)
-(CGFloat)xjr_width{
    return self.frame.size.width;
}
-(void)setXjr_width:(CGFloat)xjr_width{
    CGRect rect = self.frame;
    rect.size.width = xjr_width;
    self.frame = rect;
}
-(CGFloat)xjr_height{
    return self.frame.size.height;
}
-(void)setXjr_height:(CGFloat)xjr_height{
    CGRect rect = self.frame;
    rect.size.width = xjr_height;
    self.frame = rect;
}
-(CGFloat)xjr_x{
    return self.frame.origin.x;
}
-(void)setXjr_x:(CGFloat)xjr_x{
    CGRect rect = self.frame;
    rect.origin.x = xjr_x;
    self.frame = rect;
}
-(CGFloat)xjr_y{
    return self.frame.origin.y;
}
-(void)setXjr_y:(CGFloat)xjr_y{
    CGRect rect = self.frame;
    rect.origin.y = xjr_y;
    self.frame = rect;
}
- (CGFloat)xjr_centerX
{
    return self.center.x;
}
- (void)setXjr_centerX:(CGFloat)xjr_centerX
{
    CGPoint center = self.center;
    center.x = xjr_centerX;
    self.center = center;
}

- (CGFloat)xjr_centerY
{
    return self.center.y;
}
- (void)setXjr_centerY:(CGFloat)xjr_centerY
{
    CGPoint center = self.center;
    center.y = xjr_centerY;
    self.center = center;
}
@end
