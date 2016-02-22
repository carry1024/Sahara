//
//  RootBarController.m
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RootBarController.h"
#import "ActivityViewController.h"
#import "RunViewController.h"
#import "MyViewController.h"

@interface RootBarController ()<RootBarDelegate>

@end

@implementation RootBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ActivityViewController * activity = [[ActivityViewController alloc]initWithNibName:@"ActivityViewController" bundle:[NSBundle mainBundle]];
    
    RunViewController *run = [[RunViewController alloc]initWithNibName:@"RunViewController" bundle:[NSBundle mainBundle]];
    
    MyViewController *my = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:[NSBundle mainBundle]];
    
//    activityNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"活动"
//                                                          image:[[UIImage imageNamed:@"1_07"]
//                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                  selectedImage:[[UIImage imageNamed:@"2_07"]
//                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    activityNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    activityNav.navigationBarHidden = YES;
//    
//    runNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跑步"
//                                                     image:[[UIImage imageNamed:@"3_05"]
//                                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                             selectedImage:[[UIImage imageNamed:@"1_05"]
//                                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    runNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    runNav.navigationBarHidden = YES;
//    
//    myNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的"
//                                                 image:[[UIImage imageNamed:@"2_03"]
//                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                         selectedImage:[[UIImage imageNamed:@"3_03"]
//                                                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    myNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    myNav.navigationBarHidden = YES;
//
//    //设定Tabbar的点击后的颜色
//    [[UITabBar appearance] setTintColor:MAINCOLOR];
//    //设定Tabbar的颜色
//    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];

    self.viewControllers = @[activity,run,my];
    self.selectedIndex = 1;
    _rootBarView = [[RootBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _rootBarView.delegate =self;
    [self.view addSubview:_rootBarView];
}


#pragma RootBarDelegate

- (void) tabBar:(RootBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to {
    
    self.selectedIndex = to;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
