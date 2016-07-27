//
//  XJREssenceViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/6/2.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJREssenceViewController.h"
#import "XJRTitleButton.h"

#import "XJRAllViewController.h"
#import "XJRVideoViewController.h"
#import "XJRVoiceViewController.h"
#import "XJRPictureViewController.h"
#import "XJRWordViewController.h"

@interface XJREssenceViewController () <UIScrollViewDelegate>// <UITableViewDataSource, UITableViewDelegate>

/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) XJRTitleButton *previousClickedTitleButton;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
/** 用来显示所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation XJREssenceViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    //设置导航条的内容
    [self setupNavBar];
    // 初始化子控制器
    [self setupChildVcs];
    //scrollView
    [self setupScrollView];
    //标题栏
    [self setupTitlesView];
    // 默认显示第0个子控制器的view
    [self addChildVcViewIntoScrollView:0];
    //[self addChildVcViewIntoScrollView];

}
/**
 *  初始化子控制器
 */
- (void)setupChildVcs
{
    [self addChildViewController:[[XJRAllViewController alloc] init]];
    [self addChildViewController:[[XJRVideoViewController alloc] init]];
    [self addChildViewController:[[XJRVoiceViewController alloc] init]];
    [self addChildViewController:[[XJRPictureViewController alloc] init]];
    [self addChildViewController:[[XJRWordViewController alloc] init]];
}
/**
 *  scrollView
 */
-(void)setupScrollView {
    /*
    XJRLog(@"UITableViewController-%@",NSStringFromCGRect([[UITableViewController alloc]init].view.frame));
    XJRLog(@"UIViewController-%@",NSStringFromCGRect([[UIViewController alloc]init].view.frame));
   
    //UITableViewController-{{0, 20}, {375, 647}}
    //UIViewController-{{0, 0}, {375, 667}}
    */
    NSInteger count = self.childViewControllers.count;
    // 不要去自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    // 点击状态栏时,这个scrollView不需要滚动到顶部
    scrollView.scrollsToTop = NO;
    scrollView.frame = self.view.bounds;
    //随机色
    //scrollView.backgroundColor = XJRRandomColor;
    scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    // 其他设置
    scrollView.contentSize = CGSizeMake(count * scrollView.xjr_width, 0);
    scrollView.pagingEnabled = YES;
    // 添加5个模块
    /*
    for (NSInteger i = 0; i < count; i++) {
        
//        UITableView *tableView = [[UITableView alloc] init];
//        tableView.backgroundColor = XJRRandomColor;
//        tableView.xjr_width = scrollView.xjr_width;
//        tableView.xjr_height = scrollView.xjr_height;
//        tableView.xjr_x = i * tableView.xjr_width;
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.tag = i;
//        [scrollView addSubview:tableView];
        
        UIView *childVcView = self.childViewControllers[i].view;
        childVcView.frame = CGRectMake(i * scrollView.xjr_width, 0, scrollView.xjr_width, scrollView.xjr_height);
        //一下设置虽然不会被挡住,但是没有全屏穿透效果
        //childVcView.frame = CGRectMake(i * scrollView.xmg_width, 99, scrollView.xmg_width, scrollView.xmg_height - 99 - 49);
        //childVcView.xjr_x = i * scrollView.xjr_width;
        [scrollView addSubview:childVcView];
        //XJRLog(@"%@",NSStringFromCGRect(childVcView.frame));
        //{{0, 20}, {375, 647}}
    }
    */
}
/**
 *  标题栏
 */
-(void)setupTitlesView {
    UIView *titlesView = [[UIView alloc] init];
    titlesView.frame = CGRectMake(0, 64, self.view.xjr_width, 35);
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    // titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    // titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    // alpha会让子控件也有透明度
    // titlesView.alpha = 0.3;
    self.titlesView = titlesView;
    [self.view addSubview:titlesView];
    // 标题按钮
    [self setupTitleButtons];
    // 下划线
    [self setupTitleUnderline];
}
/**
 *  下划线
 */
- (void)setupTitleUnderline
{
    // 取出标题按钮
    XJRTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    UIView *titleUnderline = [[UIView alloc] init];
    CGFloat titleUnderlineH = 2;
    CGFloat titleUnderlineY = self.titlesView.xjr_height - titleUnderlineH;
    titleUnderline.frame = CGRectMake(0, titleUnderlineY, 0, titleUnderlineH);
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderline];
    
    self.titleUnderline = titleUnderline;
    
    // 新点击的按钮 -> 红色
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    
    // 下划线
    [firstTitleButton.titleLabel sizeToFit];
    self.titleUnderline.xjr_width = firstTitleButton.titleLabel.xjr_width + 10;
    self.titleUnderline.xjr_centerX = firstTitleButton.xjr_centerX;
}

/**
 *  标题按钮
 */
- (void)setupTitleButtons
{
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat titleButtonH = self.titlesView.xjr_height;
    CGFloat titleButtonW = self.titlesView.xjr_width / count;
    
    for (NSInteger i = 0; i < count; i++) {
        XJRTitleButton *titleButton = [[XJRTitleButton alloc] init];
        //绑定tag
        titleButton.tag = i;
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        //随机色
        titleButton.backgroundColor = XJRRandomColor;
        [self.titlesView addSubview:titleButton];
    }
}

//设置导航条的内容
-(void)setupNavBar{
    //左边
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] addTarget:self action:@selector(game)];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] addTarget:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    //中间 titleView 默认控件与图片一样大
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
#pragma mark - 监听点击
//按钮的状态讲解...
/**
 *  监听标题按钮点击
 */
- (void)titleButtonClick:(XJRTitleButton *)titleButton
{
    // 修改按钮的状态
    // 上一个点击的按钮 -> 暗灰色
    self.previousClickedTitleButton.selected = NO;
    // 新点击的按钮 -> 红色
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    NSInteger index = titleButton.tag;
    [UIView animateWithDuration:0.25 animations:^{
        /*
        // self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithFont:titleButton.titleLabel.font].width;
        // self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName : titleButton.titleLabel.font}].width;
        */
         // 下划线
        self.titleUnderline.xjr_width = titleButton.titleLabel.xjr_width + 10;
        self.titleUnderline.xjr_centerX = titleButton.xjr_centerX;
        // 滑动scrollView到对应的子控制器界面
        CGPoint offset = self.scrollView.contentOffset;
        offset.x = index * self.scrollView.xjr_width;
        //offset.x = titleButton.tag * self.scrollView.xjr_width;
        self.scrollView.contentOffset = offset;
        /*
        // self.scrollView.contentOffset = CGPointMake(titleButton.tag * self.scrollView.xjr_width, self.scrollView.contentOffset.y);
        // NSInteger index = [self.titlesView.subviews indexOfObject:titleButton];
        // self.scrollView.contentOffset = CGPointMake(index * self.scrollView.xjr_width, self.scrollView.contentOffset.y);
        */
    }completion:^(BOOL finished) {
        // 添加index位置的子控制器view到scrollView中
        [self addChildVcViewIntoScrollView:index];
        // 添加子控制器view到scrollView中
        //[self addChildVcViewIntoScrollView];

    }];
    // 控制scrollView的scrollsToTop属性
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        
        // 如果控制器的view没有被创建,跳过
        if (!childVc.isViewLoaded) continue;
        
        // 如果控制器的view不是scrollView,就跳过
        if (![childVc.view isKindOfClass:[UIScrollView class]]) continue;
        
        // 如果控制器的view是scrollView
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        scrollView.scrollsToTop = (i == index);
        //        if (i == index) { // 被点击按钮对应的子控制器
        //            scrollView.scrollsToTop = YES;
        //        } else {
        //            scrollView.scrollsToTop = NO;
        //        }
    }

}
/*
- (void)titleButtonClick:(XMGTitleButton *)titleButton
{
    // 上一个点击的按钮 -> 暗灰色
    self.previousClickedTitleButton.enabled = YES;
    // 新点击的按钮 -> 红色
    titleButton.enabled = NO;
    self.previousClickedTitleButton = titleButton;
}

- (void)titleButtonClick:(XMGTitleButton *)titleButton
{
    // 上一个点击的按钮 -> 暗灰色
    [self.previousClickedTitleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    // 新点击的按钮 -> 红色
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.previousClickedTitleButton = titleButton;
}
 */
-(void)game{
    XJRLog(@"点击了此按钮");
}
#pragma mark - 其他
/**
 *  添加index位置的子控制器view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSInteger)index
{
    /*
    UIView *childVcView = self.childViewControllers[index].view;
    childVcView.frame = CGRectMake(index * self.scrollView.xjr_width, 0, self.scrollView.xjr_width, self.scrollView.xjr_height);
    [self.scrollView addSubview:childVcView];
     */
    // 取出index位置对应的子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if (childVc.isViewLoaded) return;
    //    if (childVc.view.superview) return;
    //    if (childVc.view.window) return;
    //    if ([self.scrollView.subviews containsObject:childVc.view]) return;
    
    // 设置frame
    childVc.view.frame = CGRectMake(index * self.scrollView.xjr_width, 0, self.scrollView.xjr_width, self.scrollView.xjr_height);
    // 添加
    [self.scrollView addSubview:childVc.view];
}
/**
 *  添加子控制器view到scrollView中
 */
- (void)addChildVcViewIntoScrollView
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.xjr_width;
    UIView *childVcView = self.childViewControllers[index].view;
    
    childVcView.frame = self.scrollView.bounds;
    /*
    childVcView.frame = CGRectMake(self.scrollView.bounds.origin.x,
                                       self.scrollView.bounds.origin.y,
                                       self.scrollView.bounds.size.width,
                                       self.scrollView.bounds.size.height);
    
    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x,
                                       self.scrollView.contentOffset.y,
                                       self.scrollView.xjr_width,
                                       self.scrollView.xjr_height);
    
    childVcView.frame = CGRectMake(index * self.scrollView.xjr_width,
                                       0,
                                       self.scrollView.xjr_width,
                                       self.scrollView.xjr_height);
    */
    [self.scrollView addSubview:childVcView];
}
#pragma mark - <UITableViewDataSource>
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) return 10;
    if (tableView.tag == 1) return 30;
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.class, indexPath.row];

    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {

    }
    XMGLog(@"点击第%zd个表格的第%zd行", tableView.tag, indexPath.row)
}
*/
/*
 凡是NSDictionary *类型的attributes参数, 一般都有以下规律
 一.iOS7以前
 1.key都来源于UIStringDrawing.h
 2.key的格式都是:UITextAttribute***
 
 二.iOS7开始
 1.key都来源于NSAttributedString.h
 2.key的格式都是:NS***AttributeName
 */
#pragma mark - <UIScrollViewDelegate>
/*
 -[UIView setSelected:]: unrecognized selector sent to instance 0x7ff3f35b1070
 
 -[XMGPerson length]: unrecognized selector sent to instance 0x7ff3f35b1070
 错误将XMGPerson当做NSString来使用,比如
 id obj = [[XMGPerson alloc] init];
 NSString *string = obj;
 string.length;
 
 -[XMGPerson count]: unrecognized selector sent to instance 0x7ff3f35b1070
 id obj = [[XMGPerson alloc] init];
 NSArray *array = obj;
 array.count;
 
 -[XMGPerson setObject:forKeyedSubscript:]: unrecognized selector sent to instance 0x7ff3f35b1070
 错误将XMGPerson当做NSMutableDictionary来使用
 
 规律: 方法名里面包含了Subscript的方法,一般都是集合的方法(比如字典\数组)
 */
/**
 *  scrollView滑动完毕的时候调用(速度减为0的时候调用)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.xjr_width;
    XJRTitleButton *titleButton = self.titlesView.subviews[index];
    //XJRTitleButton *titleButton = [self.titlesView viewWithTag:index];
    [self titleButtonClick:titleButton];
}

/**
 *  停止拖拽scrollView的时候调用(松开scrollView的时候调用)
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    XJRFunc
//}

// Decelerate : 减速
// Accelerate : 加速

// asc : 升序  1,2,3,4,5,6
// desc : 降序 6,5,4,3,2,1

/*
 //递归查找
 @implementation UIView
 - (UIView *)viewWithTag:(NSInteger)tag
 {
 // 如果自己的tag符合要求, 就返回自己
 if (self.tag == tag) return self;
 
 // 遍历子控件,查找tag符合要求的子控件
 for (UIView *subview in self.subviews) {
 //        if (subview.tag == tag) return subview;
 
 UIView *resultView = [subview viewWithTag:tag];
 if (resultView) return resultView;
 }
 
 // 找不到符合要求的子控件
 return nil;
 }
 @end
 */
@end
