//
//  XJRFastLoginView.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRFastLoginView.h"

@implementation XJRFastLoginView

+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XJRFastLoginView" owner:nil options:nil] firstObject];
}

@end
