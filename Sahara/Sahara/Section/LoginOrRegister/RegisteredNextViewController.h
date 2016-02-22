//
//  RegisteredNextViewController.h
//  Sahara
//
//  Created by heng on 15/12/8.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface RegisteredNextViewController : FatherViewController
@property (strong) NSMutableDictionary *info;
@property (strong) UIImage *image;

//判断是用户注册还是三方注册：默认用户注册（NO）， 三方注册（YES）
@property (nonatomic) BOOL isRegistered;


//男按钮
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
//女按钮
@property (weak, nonatomic) IBOutlet UIButton *womanButton;
//当前选中按钮
@property (nonatomic, strong) UIButton *currentButton;

#pragma mark - 用户注册
//手机号码
@property (nonatomic, strong) NSString *phoneNumber;
//验证码
@property (nonatomic, strong) NSString *verification;
//密码
@property (nonatomic, strong) NSString *password;

#pragma mark - 三方注册
//第三方key
@property (nonatomic, strong) NSString *thirdKey;
//性别
@property (nonatomic) NSInteger sexValue;
//第三方类型
@property (nonatomic, strong) NSString *thirdProvider;
//第三方名字
@property (nonatomic, strong) NSString *thirdName;
//第三方头像
@property (nonatomic, strong) NSString *thirdHeaderImage;

@end
