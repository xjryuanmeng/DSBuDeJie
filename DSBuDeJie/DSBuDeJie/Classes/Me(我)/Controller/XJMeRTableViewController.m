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

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (XJRScreenW - ((cols - 1) * margin)) / cols
// 按钮选中状态 必须 手动设置

@interface XJMeRTableViewController()<UICollectionViewDataSource>

@property (nonatomic ,strong) NSMutableArray *squareItems;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation XJMeRTableViewController
/*
 1.collectionView高度 -> cell行数
 2.collectionView不能滚动
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor purpleColor];
    //设置导航条的内容
    [self setupNavBar];
    //设置footView
    [self setupFootView];
    //加载数据
    [self loadData];
}
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
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 845) collectionViewLayout:layout];
    _collectionView = collectionView;
    collectionView.backgroundColor = XJRGlobleColor;
    self.tableView.tableFooterView = collectionView;
    // 设置数据源
    collectionView.dataSource = self;
    // 注册cell
    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"XJRSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    _collectionView.scrollEnabled = NO;
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
