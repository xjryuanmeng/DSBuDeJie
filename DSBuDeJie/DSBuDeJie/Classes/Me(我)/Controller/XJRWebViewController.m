//
//  XJRWebViewController.m
//  DSBuDeJie
//
//  Created by 邢京荣 on 16/7/21.
//  Copyright © 2016年 邢京荣. All rights reserved.
//

#import "XJRWebViewController.h"
#import <WebKit/WebKit.h>

@interface XJRWebViewController ()
@property (nonatomic, weak) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@end

@implementation XJRWebViewController
/*
 使用步骤
 1.导入 WebKit框架
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加WKWebView
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    _webView = webView;
    [self.view insertSubview:webView atIndex:0];
    //[self.view addSubview:webView];
    //加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [webView loadRequest:request];
    // KVO: 让self对象监听webView的estimatedProgress
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
// 只要监听的属性有新值就会调用
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    _progressView.progress = _webView.estimatedProgress;
    _progressView.hidden = _progressView.progress >= 1;
}
//KVO一定要移除观察者
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
@end
