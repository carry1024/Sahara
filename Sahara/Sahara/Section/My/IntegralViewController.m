//
//  IntegralViewController.m
//  Sahara
//
//  Created by heng on 16/1/25.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "IntegralViewController.h"

@interface IntegralViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView; /**< 网页视图 */
@end

@implementation IntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomNavBarTitle:@"积分&等级规则" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 加载网页视图
    [self.view addSubview:self.webView];
}

#pragma mark - getter
- (UIWebView *)webView {
    if (!_webView) {
        // 初始化网页视图
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth,  ScreenHeight - 64)];
        
        // 配置URL：http:// +...
        NSURL *url = [NSURL URLWithString:@"http://sahara195.com/Home/Integral"];
        
        // 创建请求
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        // 自动对页面进行缩放以适应屏幕
        _webView.scalesPageToFit = YES;
        
        // 自动检测网页上的电话号码，单击可以拨打
        // _webView.detectsPhoneNumbers = YES;
        
        // 加载网页
        [_webView loadRequest:request];
        
        // 设置代理
        _webView.delegate = self;
        
        // 设置是否回弹
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}
@end
