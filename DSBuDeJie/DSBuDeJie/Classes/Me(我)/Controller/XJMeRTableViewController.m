//
//  XJMeRTableViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJMeRTableViewController.h"
#import "XJRSettingViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "XJRSquareItem.h"
#import "XJRSquareCell.h"
#import <SafariServices/SafariServices.h>
#import "XJRWebViewController.h"

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (XJRScreenW - ((cols - 1) * margin)) / cols
// 按钮选中状态 必须 手动设置

@interface XJMeRTableViewController()<UICollectionViewDataSource,UICollectionViewDelegate,SFSafariViewControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *squareItems;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation XJMeRTableViewController
/*
 1.collectionView高度 -> cell行数
 2.collectionView不能滚动
 */
//处理cell间距
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor purpleColor];
    //设置导航条的内容
    [self setupNavBar];
    //设置footView
    [self setupFootView];
    //加载数据
    [self loadData];
    //设置tableView组间距
    //如果是分组样式,默认每一组都会有头部间距和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    //设置顶部额外滚动区域-25
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}
/*
//只为验证tableView顶部多出的尺寸
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    NSLog(@"%f",self.tableView.contentInset.top);
}
 */
// 处理数据
- (void)resolveData
{
    // 判断缺几个
    // 3 % 4 = 3 4 - 1 0
    NSInteger count = self.squareItems.count;
    NSInteger extre = count % cols;
    if (extre) { // 补模型
        extre = cols - extre;
        for (int i = 0; i < extre; i++) {
            XJRSquareItem *item = [[XJRSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
}
-(void)loadData{
    //发送请求-->查看接口文档-->AFN
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    [mgr GET:@"http://api.budejie.com/api/api_open.php"  parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        // 字典数组
        NSArray *dictArr = responseObject[@"square_list"];
        // 字典数组转换层模型数组
        _squareItems = [XJRSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        // 处理数据
        [self resolveData];
        // 刷新表格
        [self.collectionView reloadData];
        // 4 5 9
        // 设置collectionView高度 => 跟行数 => 总个数 行数:(count - 1) / cols + 1
        NSInteger count = _squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        CGFloat collectionH = rows * itemWH + (rows - 1) * margin;
        self.collectionView.xjr_height = collectionH;
        //NSLog(@"%f",collectionH);
        // 设置tableView滚动范围 => tableView滚动范围是系统会自动根据内容去计算
        self.tableView.tableFooterView = self.collectionView;
        //self.tableView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.collectionView.frame));
        [responseObject writeToFile:@"/Users/xingjingrong/Desktop/GIT/GitHub/DSBuDeJie/DSBuDeJie/DSBuDeJie/Classes/Me(我)/square.plist" atomically:YES];
        //NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
/*
 1.UICollectionView初始化必须要设置布局
 2.cell必须注册
 3.自定义cell
*/
-(void)setupFootView{
    //流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    //cell的间距
    layout.minimumInteritemSpacing = margin;
    layout.minimumLineSpacing = margin;
    //创建collectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    _collectionView = collectionView;
    //NSLog(@"%f",self.collectionView.xjr_height);
    collectionView.backgroundColor = XJRGlobleColor;
    self.tableView.tableFooterView = collectionView;
    // 设置数据源
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册cell
    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"XJRSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    //_collectionView.scrollEnabled = NO;
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.squareItems.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XJRSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.row];
    //cell.backgroundColor = [UIColor yellowColor];
    return cell;
}
#pragma mark -UICollectionViewDelegate
//点击cell就会调用
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取模型
    XJRSquareItem *item = self.squareItems[indexPath.row];
    if (![item.url containsString:@"http"]) return;
    NSURL *url = [NSURL URLWithString:item.url];
    //UIWebView :在当前应用打开
    //UIWebView没有这些功能,必须手动去实现,进度条做不了.
    //Safari:跳转到Safari应用,离开当前应用
    //safar:自带很多功能,前进.后退,刷新,进度条,网址
    
    //在当前应用打开网页,但是要有Safari功能,自己去写
    //iOS9 : SFSafariViewController :在当前应用打开网页,跟Safari同样的功能
    //第一步:导入 #import <SafariServices/SafariServices.h>
    /*
    SFSafariViewController *safariVc = [[SFSafariViewController alloc]initWithURL:url];
    //处理Done按钮
    safariVc.delegate = self;
    [self.navigationController pushViewController:safariVc animated:YES];
    self.navigationController.navigationBarHidden = YES;
     */
    //这句代码完美解决Done按钮的点击事件,无需设置代理,遵守协议,实现方法(代替设置代理的方法)
    //[self presentViewController:safariVc animated:YES completion:nil];
    // WKWebView:UIWebView升级版,监听进度条,数据缓存,iOS8才有
    XJRWebViewController *webVc = [[XJRWebViewController alloc]init];
    webVc.url = url;
    [self.navigationController pushViewController:webVc animated:YES];
}
#pragma mark - SFSafariViewControllerDelegate
/*
-(void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    //NSLog(@"点击了done按钮");
}
*/
//设置导航条的内容
-(void)setupNavBar{
    //右边边
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] addTarget:self action:@selector(setting)];
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] addTarget:self action:@selector(night:)];
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.title = @"我的";
}
- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
    
}
//点击设置按钮就会调用
- (void)setting
{
    /*
     问题:
     1.底部条没有隐藏
     2.返回按钮样式
     */
    
    //设置界面有自己的业务逻辑,因此要自定义,方便自己的事情自己管理,方便以后精确查找,修改
    XJRSettingViewController *settingVc = [[XJRSettingViewController alloc]init];
    //一定要注意在Push之前去设置这个属性(Push谁就拿到谁去设置这个属性)
    settingVc.hidesBottomBarWhenPushed = YES;
    //跳转到设置界面
    [self.navigationController pushViewController:settingVc animated:YES];
}
@end
