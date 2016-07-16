//
//  UIBarButtonItem+XJRItem.h
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XJRItem)
+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage addTarget:(id)target action:(SEL)action;
+(UIBarButtonItem *)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage addTarget:(id)target action:(SEL)action;
@end
