//
//  XJRSubTagViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "XJRSubTagItem.h"
#import "XJRSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const ID = @"cell";

@interface XJRSubTagViewController ()
@property(nonatomic, strong)NSArray *subTags;
@property(nonatomic, weak)NSURLSessionDataTask *task;
@end

@implementation XJRSubTagViewController
//让分隔线全屏-->1.自定义分隔线 2.利用系统属性(iOS6->iOS7 , iOS7 -> iOS8)不能支持iOS8 3.重写cell的setFrame方法,1.取消系统的分隔线2.设置tableView的背景色为分割线的颜色
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.title = @"推荐标签";
    //加载数据
    [self loadData];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"XJRSubTagCell" bundle:nil] forCellReuseIdentifier:ID];
    /*
     //设置分隔线占据全屏(ios7可以解决--ios8解决不了(多了约束边缘))
     self.tableView.separatorInset = UIEdgeInsetsZero;
     //可能搞错对象了-->设置cell的这个属性
     //self.tableView.layoutMargins = UIEdgeInsetsZero;
     */
    //取消系统的分隔线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置tableView的背景色
    self.tableView.backgroundColor =  XJRColor(215, 215, 215);
}
-(void)viewWillDisappear:(BOOL)animated{
    //移除指示器
    [SVProgressHUD dismiss];
    //取消请求
    [_task cancel];
}
#pragma mark - 加载数据
-(void)loadData{
    //查看接口文档-->发送请求-->解析数据(image_list,theme_name,sub_number)
    //1.创建请求会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"c"] = @"topic";
    parameters[@"action"] = @"sub";
    //提示用户
    [SVProgressHUD showWithStatus:@"正在加载ing......"];
    //3.发送请求
    _task = [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除指示器
        [SVProgressHUD dismiss];
        //解析数据-->写成plist文件
        [responseObject writeToFile:@"/Users/xingjingrong/Desktop/DSBuDeJie/subtag.plist" atomically:YES];
        //字典数组转模型数组(创建模型)
        _subTags = [XJRSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除指示器
        [SVProgressHUD dismiss];
    }];
}
#pragma mark - Table view data source
//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.subTags.count;
}
//返回每一个cell长什么样子
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XJRSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.item = self.subTags[indexPath.row];
    //设置分隔线全屏
    //cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}
//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置cell高度
    return 60;
}
@end
