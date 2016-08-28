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
#import <SVProgressHUD.h>

@interface XJRAllViewController ()
/** 所有的帖子数据(里面都是XJRTopic模型)*/
@property (nonatomic, strong) NSMutableArray *topics;
/** 用来加载下一页数据的参数 */
@property (nonatomic, copy) NSString *maxtime;
/** 发送请求的管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 用来下拉加载新数据的header */
@property (nonatomic, weak) UILabel *header;
/** 是否正在加载新数据... */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;

/** 用来上拉加载更多数据的footer */
@property (nonatomic, weak) UILabel *footer;
/** 是否正在加载更多数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
@end

@implementation XJRAllViewController
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = XJRRandomColor;
    self.tableView.contentInset = UIEdgeInsetsMake(XJRNavBarMaxY + XJRTitlesViewH, 0, XJRTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    // 加载最新的帖子数据
    //[self loadNewTopics];
    // 添加刷新控件
    [self setupRefresh];
}
/**
 *  添加刷新控件
 */
- (void)setupRefresh
{
    // 广告
    UILabel *ad = [[UILabel alloc] init];
    ad.textAlignment = NSTextAlignmentCenter;
    ad.textColor = [UIColor whiteColor];
    ad.text = @"广告广告广告广告广告";
    ad.backgroundColor = [UIColor grayColor];
    ad.xjr_height = 35;
    self.tableView.tableHeaderView = ad;
    //搜索框
    //    UISearchBar *searchBar = [[UISearchBar alloc] init];
    //    searchBar.xmg_height = 44;
    //    self.tableView.tableHeaderView = searchBar;
    
    // 下拉加载新数据的控件
    UILabel *header = [[UILabel alloc] init];
    header.textAlignment = NSTextAlignmentCenter;
    header.textColor = [UIColor whiteColor];
    header.text = @"下拉可以刷新";
    header.backgroundColor = [UIColor redColor];
    header.xjr_height = 50;
    header.xjr_y = - header.xjr_height;
    header.xjr_width = self.tableView.xjr_width;
    [self.tableView addSubview:header];
    self.header = header;
    
    // 马上进入刷新状态
    [self headerBeginRefreshing];
    
    // 上拉加载更多数据的控件
    UILabel *footer = [[UILabel alloc] init];
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor whiteColor];
    footer.text = @"上拉加载更多数据";
    footer.backgroundColor = [UIColor redColor];
    footer.xjr_height = 35;
    self.tableView.tableFooterView = footer;
    self.footer = footer;
}
#pragma mark - 数据
/**
 *  加载最新的帖子数据(首页数据, 第1页)
 */
- (void)loadNewTopics
{
    // 取消请求
    // 仅仅是取消请求, 不会关闭session
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // [self footerEndRefreshing];
    
    // 关闭session并且取消请求(session一旦被关闭了, 这个manager就没法再发送请求)
    // [self.manager invalidateSessionCancelingTasks:YES];
    //  self.manager = nil;
    
    // 创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"31"; //数字参数, 也可以使用NSNumber类型@1
    // 发送请求
    [[AFHTTPSessionManager manager] GET:XJRRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数组
        self.topics = [XJRTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新(恢复刷新控件的状态)
        [self headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新(恢复刷新控件的状态)
        [self headerEndRefreshing];
        // 如果是因为取消任务来到failure这个block, 就直接返回, 不需要提醒错误信息
        if (error.code == NSURLErrorCancelled) return;
        // 请求失败的提醒
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试!"];
    }];
    // 一个任务被取消了, 会调用AFN请求的failure这个block
    // [task cancel];
}
/**
 *  加载更多的帖子数据
 */
- (void)loadMoreTopics
{
    // 取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // [self headerEndRefreshing];
    // 创建请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @"31"; //数字参数, 也可以使用NSNumber类型@1
    parameters[@"maxtime"] = self.maxtime;
    // 发送请求
    [[AFHTTPSessionManager manager] GET:XJRRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 字典数组 -> 模型数组
        NSArray *moreTopics = [XJRTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:moreTopics];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新(恢复刷新控件的状态)
        [self footerEndRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新(恢复刷新控件的状态)
        [self footerEndRefreshing];
        // 如果是因为取消任务来到failure这个block, 就直接返回, 不需要提醒错误信息
        if (error.code == NSURLErrorCancelled) return;
        // 请求失败的提醒
        [SVProgressHUD showErrorWithStatus:@"网络繁忙,请稍后再试!"];
    }];
}
#pragma mark - 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self headerBeginRefreshing];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 如果正在刷新, 直接返回
    if (self.isHeaderRefreshing) return;
    // 当偏移量 <= offsetY时, 刷新header就完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.xjr_height);
    
    if (self.tableView.contentOffset.y <= offsetY) { // 刷新header完全出现了
        // 进入刷新状态
        [self headerBeginRefreshing];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 处理Header
    [self dealHeader];
    // 处理footer
    [self dealFooter];
}
#pragma mark - header
/**
 *  处理Header
 */
- (void)dealHeader
{
    // header还没有被创建, 直接返回
    if (self.header == nil) return;
    // 如果正在刷新, 直接返回
    if (self.isHeaderRefreshing) return;
    // 当偏移量 <= offsetY时, 刷新header就完全出现
    CGFloat offsetY = - (self.tableView.contentInset.top + self.header.xjr_height);
    
    if (self.tableView.contentOffset.y <= offsetY) { // 刷新header完全出现了
        self.header.text = @"松开立即刷新";
        self.header.backgroundColor = [UIColor purpleColor];
    } else {
        self.header.text = @"下拉可以刷新";
        self.header.backgroundColor = [UIColor redColor];
    }
}
/**
 *  header进入刷新状态
 */
- (void)headerBeginRefreshing
{
    if (self.isHeaderRefreshing) return;
    //    if (self.isFooterRefreshing) return;
    
    self.headerRefreshing = YES;
    self.header.text = @"正在刷新数据...";
    self.header.backgroundColor = [UIColor blueColor];
    // 增大内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.xjr_height;
        self.tableView.contentInset = inset;
        
        CGPoint offset = self.tableView.contentOffset;
        offset.y = - inset.top;
        self.tableView.contentOffset = offset;
    }];
    // 发送请求给服务器
    [self loadNewTopics];
}
/**
 *  header结束刷新状态
 */
- (void)headerEndRefreshing
{
    self.headerRefreshing = NO;
    // 减小内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.xjr_height;
        self.tableView.contentInset = inset;
    }];
}
#pragma mark - footer
/**
 *  处理footer
 */
- (void)dealFooter
{
    // 如果还没有数据, 不需要处理footer
    if (self.topics.count == 0) return;
    // 如果正在上拉刷新(加载更多数据), 直接返回
    if (self.isFooterRefreshing) return;
    // 当偏移量 >= offsetY时, footer就完全出现, 进入上拉加载数据状态
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.xjr_height;
    if (self.tableView.contentOffset.y >= offsetY) {
        // 进入刷新状态
        [self footerBeginRefreshing];
    }
}
/**
 *  footer进入刷新状态
 */
- (void)footerBeginRefreshing
{
    // if (self.isHeaderRefreshing) return;
    if (self.isFooterRefreshing) return;
    
    self.footerRefreshing = YES;
    self.footer.text = @"正在加载更多数据...";
    self.footer.backgroundColor = [UIColor blueColor];
    // 发送请求给服务器, 加载更多的数据
    [self loadMoreTopics];
}
/**
 *  footer结束刷新状态
 */
- (void)footerEndRefreshing
{
    self.footerRefreshing = NO;
    self.footer.text = @"上拉加载更多数据";
    self.footer.backgroundColor = [UIColor redColor];
}
#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.footer.hidden = (self.topics.count == 0);

    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    XJRTopic *topic = self.topics[indexPath.row];
    
    cell.textLabel.text = topic.name;
    cell.detailTextLabel.text = topic.text;
    
    return cell;
}
@end
