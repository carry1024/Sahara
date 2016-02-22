//
//  startPageViewController.m
//  Sahara
//
//  Created by junzong on 16/1/25.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "startPageViewController.h"
#import "Archive.h"

@interface startPageViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation startPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSArray *array = @[@"引导页1",@"引导页2"];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * array.count, ScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = RGBA(252, 145, 53, 1);
    [self.view addSubview:_scrollView];
    
    
    
    
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight)];
        imageView.image = [UIImage imageNamed:array[i]];
        [_scrollView addSubview:imageView];
        
        if (i == array.count - 1) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = [startPageViewController buttonRect];
            [button setBackgroundImage:[UIImage imageNamed:@"立即体验"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(startPageEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
        
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth - 200) / 2, ScreenHeight - 50, 200, 20)];
    _pageControl.numberOfPages = array.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = RGBA(252, 145, 53, 1);
    [self.view addSubview:_pageControl];
    
}

- (void)startPageEvent:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"statrtPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = round(scrollView.contentOffset.x / ScreenWidth);
}


+(CGRect)buttonRect
{
    CGRect rect;
    if (IS_IPHONE_6) {
        rect = CGRectMake(ScreenWidth + (ScreenWidth - 220) / 2, ScreenHeight - 150, 220, 40);
    }else if (IS_IPHONE_6_PLUS){
        rect = CGRectMake(ScreenWidth + (ScreenWidth - 250) / 2, ScreenHeight - 170, 250, 45);
    }else{
        rect = CGRectMake(ScreenWidth + (ScreenWidth - 200) / 2, ScreenHeight - 125, 200, 35);
    }
    
    return rect;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
