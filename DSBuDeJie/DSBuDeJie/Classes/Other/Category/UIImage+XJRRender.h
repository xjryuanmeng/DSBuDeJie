//
//  UIImage+XJRRender.h
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/3.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XJRRender)
//提供一个不要渲染的图片
+(UIImage *)imageNameWithOriginal:(NSString *)imageName;
// 生成一个圆角图片
- (UIImage *)circleImage;
@end
