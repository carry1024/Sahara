//
//  FatherViewController.m
//  Sahara
//
//  Created by huangcan on 15/5/20.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "FatherViewController.h"
@interface FatherViewController ()


@end

@implementation FatherViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBarTintColor:MAINCOLOR];
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)addCustomNavBarTitle:(NSString *)title
                    leftBar:(UIButton *)leftButton
                   rigthBar:(UIButton *)rigthButton whetherAddBackBar:(BOOL)backBar {
    UIView * navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navView.backgroundColor = MAINCOLOR;
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navView.center.x - 80, 20, 160, 44)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    if (leftButton && backBar == NO) {
        leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
        leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        leftButton.titleLabel.textColor = [UIColor whiteColor];
        leftButton.frame = CGRectMake(15, 20, 44, 44);
        [navView addSubview:leftButton];
    } else if (backBar == YES) {
        [navView addSubview:[self addBackBtn]];
    } else if (backBar == YES && leftButton) {
        [navView addSubview:[self addBackBtn]];
        leftButton.frame = CGRectMake(45, 20, 40, 40);
    }
    if (rigthButton) {
        rigthButton.titleLabel.textColor = [UIColor whiteColor];
        rigthButton.titleLabel.font = [UIFont systemFontOfSize:18];
        rigthButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        rigthButton.frame = CGRectMake(ScreenWidth - 59, 20, 44, 44);
        [navView addSubview:rigthButton];
    }
}
//返回按钮
- (UIButton *)addBackBtn {
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popViewConDelay)forControlEvents:UIControlEventTouchUpInside];
    return backBtn;
}

- (void)popViewConDelay
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationItem.titleView      = titleLabel;
}

//保存用户信息
- (void)saveUserInformation:(NSDictionary *)dic
{
    [UserData UserDefaults:dic[@"Height"] key:@"Height"];
    [UserData UserDefaults:dic[@"Weight"] key:@"Weight"];
    [UserData UserDefaults:dic[@"Token"] key:@"Token"];
    [UserData UserDefaults:dic[@"PhoneNo"] key:@"PhoneNo"];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
