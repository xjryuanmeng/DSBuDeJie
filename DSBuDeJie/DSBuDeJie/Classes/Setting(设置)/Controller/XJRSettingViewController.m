//
//  XJRSettingViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/4.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRSettingViewController.h"
#import <SDImageCache.h>
#define cachePath  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
static NSString * const ID = @"cell";
@interface XJRSettingViewController ()

@end

@implementation XJRSettingViewController
// 整个应用程序下所有的返回按钮都一样 -> 如何统一设置返回按钮(每次push都需要设置返回按钮)
- (void)viewDidLoad {
    [super viewDidLoad];
    // 通过这个方式去设置导航标题
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:UIBarButtonItemStyleDone target:self action:@selector(jump)];
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}
- (void)jump
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击返回按钮做事情(此处只能单独设置自己的返回按钮,而不能设置全局的,因此将此处代码移植到导航控制器中)
/*
-(void)back {
    //返回上一个控制器
    [self.navigationController popViewControllerAnimated:YES];
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //从缓存池取出cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    //获取缓存尺寸->SDWebImage和WKWebView
    //SDWebImage:怎么做缓存,沙盒Cache
    //获取SDWebImage缓存尺寸
    //NSInteger fileSize = [[SDImageCache sharedImageCache]getSize];
    //NSLog(@"%ld",fileSize);
    /*
    //获取Cache文件路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",cachePath);
    // b ->b / 1000 KB ->KB / 1000 MB
    NSInteger totalSize = [self getDirectorySize:cachePath];
    NSString *str = @"清除缓存";
    if (totalSize > 1000 * 1000) {//MB
        CGFloat totalSizeF = totalSize / 1000.0 / 1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fMB)",str,totalSizeF];
    } else if (totalSize > 1000) {//KB
        CGFloat totalSizeF = totalSize / 1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fKB)",str,totalSizeF];
    } else {//B
        str = [NSString stringWithFormat:@"%@(%ldB)",str,totalSize];
    }
    NSLog(@"%ld",totalSize);
     */
    cell.textLabel.text = [self getFileSizeStr];
    //cell.textLabel.text = @"清除缓存";
    return cell;
}
//点击cell就会调用
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //清空缓存
    //获取Cache文件下所有文件
    //获取文件夹下一级目录
    NSArray *subpaths = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:cachePath error:nil];
    for (NSString *subpath in subpaths) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:subpath];
        //指定文件路径清空
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
    //刷新表格
    [self.tableView reloadData];
}
//获取文件尺寸字符串
-(NSString *)getFileSizeStr{
    //获取Cache文件路径
    //NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",cachePath);
    // b ->b / 1000 KB ->KB / 1000 MB
    //获取文件夹尺寸
    NSInteger totalSize = [self getDirectorySize:cachePath];
    NSString *str = @"清除缓存";
    if (totalSize > 1000 * 1000) {//MB
        CGFloat totalSizeF = totalSize / 1000.0 / 1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fMB)",str,totalSizeF];
    } else if (totalSize > 1000) {//KB
        CGFloat totalSizeF = totalSize / 1000.0;
        str = [NSString stringWithFormat:@"%@(%.1fKB)",str,totalSizeF];
    } else if (totalSize > 0) {//B
        str = [NSString stringWithFormat:@"%@(%ldB)",str,totalSize];
    }
    return str;
}
//获取文件尺寸
-(NSInteger)getDirectorySize:(NSString *)directoryPath{
    //获取Cache文件路径
    //NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //获取default
    NSString *defaultPath = [directoryPath stringByAppendingPathComponent:@"default"];
   
    //获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //获取default文件夹下所有的文件
    NSArray *subpaths = [mgr subpathsAtPath:defaultPath];
    NSInteger totalSize = 0;
    for (NSString *subpath in subpaths) {
        //拼接全路径
        NSString *filePath = [defaultPath stringByAppendingPathComponent:subpath];
        //排除文件夹
        BOOL isDirectory;
        BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist ||isDirectory) continue;
        //隐藏文件
        if ([filePath containsString:@".DS"]) continue;
        //attributesOfItemAtPath:只能获取文件属性
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [attr fileSize];
        totalSize += size;
        //NSLog(@"%@",subpath);
    }
    NSLog(@"%ld",totalSize);
    //指定路径获取这个路径的属性
    //attributesOfItemAtPath:文件夹路径
    //NSDictionary *attr = [mgr attributesOfItemAtPath:defaultPath error:nil];
    //[attr fileSize];
    //NSLog(@"%@",attr);
    //NSLog(@"%lld",[attr fileSize]);
    return totalSize;
}
@end
