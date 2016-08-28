//
//  XJRAllViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/23.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRAllViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XJRTopic.h"

@interface XJRAllViewController ()
/** 所有的帖子数据(里面都是XJRTopic模型)*/
@property (nonatomic, strong) NSMutableArray *topics;
@end

@implementation XJRAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = XJRRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(XJRNavBarMaxY + XJRTitlesViewH, 0, XJRTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 加载最新的帖子数据
    [self loadNewTopics];
}
/**
 *  加载最新的帖子数据
 */
- (void)loadNewTopics
{
    // 创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"31"; //数字参数, 也可以使用NSNumber类型@1
    
    // 发送请求
    [[AFHTTPSessionManager manager] GET:XJRRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 字典数组 -> 模型数组
        self.topics = [XJRTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    XJRTopic *topic = self.topics[indexPath.row];
    
    cell.textLabel.text = topic.name;
    cell.detailTextLabel.text = topic.text;
    
    return cell;
}
@end
