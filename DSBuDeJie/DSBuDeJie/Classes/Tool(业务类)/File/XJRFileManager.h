//
//  XJRFileManager.h
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/22.
//  Copyright © 2016年 邢京荣. All rights reserved.
//  专门用于处理文件业务

#import <Foundation/Foundation.h>

@interface XJRFileManager : NSObject
/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getDirectorySize:(NSString *)directoryPath;


/**
 *  删除文件夹下所有文件
 *
 *  @param directoryPath 文件夹全路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
