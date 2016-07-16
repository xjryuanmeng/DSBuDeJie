//
//  XJRADItem.h
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/1.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import <Foundation/Foundation.h>

//w_picurl,ori_curl:广告界面跳转地址,w,h
@interface XJRADItem : NSObject
/*广告图片*/
@property(nonatomic, strong) NSString *w_picurl;
/*广告图片跳转地址*/
@property(nonatomic, strong) NSString *ori_curl;
@property(nonatomic, assign) CGFloat w;
@property(nonatomic, assign) CGFloat h;

@end
