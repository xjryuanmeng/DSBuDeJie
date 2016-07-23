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

@interface XJREssenceViewController ()// <UITableViewDataSource, UITableViewDelegate>

/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) XJRTitleButton *previousClickedTitleButton;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = XJRRandomColor;
    //scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    // 添加5个模块
    for (NSInteger i = 0; i < 5; i++) {
        /*
        UITableView *tableView = [[UITableView alloc] init];
        tableView.backgroundColor = XJRRandomColor;
        tableView.xjr_width = scrollView.xjr_width;
        tableView.xjr_height = scrollView.xjr_height;
        tableView.xjr_x = i * tableView.xjr_width;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = i;
        [scrollView addSubview:tableView];
        */
        UIView *childVcView = self.childViewControllers[i].view;
        childVcView.xjr_x = i * scrollView.xjr_width;
        [scrollView addSubview:childVcView];
    }
    
    // 其他设置
    scrollView.contentSize = CGSizeMake(5 * scrollView.xjr_width, 0);
    scrollView.pagingEnabled = YES;
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
    
    // 下划线
    [UIView animateWithDuration:0.25 animations:^{
        // self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithFont:titleButton.titleLabel.font].width;
        // self.titleUnderline.xmg_width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName : titleButton.titleLabel.font}].width;
        
        self.titleUnderline.xjr_width = titleButton.titleLabel.xjr_width + 10;
        self.titleUnderline.xjr_centerX = titleButton.xjr_centerX;
    }];

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
@end
