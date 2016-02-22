//
//  LoginViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteredViewController.h"
#import "RegisteredNextViewController.h"
#import "ForgotViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "RootBarController.h"
#import "WXApi.h"

#import <ShareSDK/ISSPlatformUser.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BingPhone.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

@property (weak, nonatomic) IBOutlet UIImageView *weChat;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userName.delegate = self;
    _userPassword.delegate = self;
    _userPassword.keyboardType = UIKeyboardTypeASCIICapable;
    if ([WXApi isWXAppInstalled] == NO) {
        _weChat.hidden = YES;
        _sinaConstraint.constant = 0;
        _qqConstraint.constant   = 0;
    }
    _userName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入11位手机号" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _userPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入6-12位密码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    在这里面判断
    if (range.location >= 11 && self.userName == textField) {
//        _userName.text = [textField.text substringToIndex:20];
        return NO;
    }
    if (range.location >= 12 && self.userPassword == textField) {
        return NO;
    }
    return YES;
}
//登陆
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.userName) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    }
}
- (IBAction)loginBtnAction:(UIButton *)sender {
    
    if (_userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (![_userName.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (_userPassword.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (_userPassword.text.length < 6 || _userPassword.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
        return;
    }
    
    [RequestManager PostUrl:URI_LOGIN_LOGIN loding:@"登录中..." dic:@{@"PhoneNo":_userName.text,@"Password":_userPassword.text,@"clientVersion":VERSION,@"loginDevice":@"2",@"registKey":@""} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            //存储登陆方式
            [[NSUserDefaults standardUserDefaults] setObject:@"phoneLogin" forKey:@"isThirdWithPhoneLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            //保存用户信息到本地
            [self saveUserInformation:response[@"ReturnData"]];
            
            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
        } else {
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
    }];
}
//注册
- (IBAction)registeredBtnAction:(UIButton *)sender {
    RegisteredViewController *registered = [[RegisteredViewController alloc] initWithNibName:@"RegisteredViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:registered animated:YES];
}
//忘记密码
- (IBAction)forgotAction:(UIButton *)sender {
    ForgotViewController *forgot = [[ForgotViewController alloc] init];
    [self.navigationController pushViewController:forgot animated:YES];
}

//QQ新浪
- (IBAction)LoginQQWithSina:(UITapGestureRecognizer *)sender {
    loginType   = sender.view.tag;
    
    //取消授权
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    
    [ShareSDK getUserInfoWithType:(int)sender.view.tag //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo,  id error) {
                               
                               //返回回调
                               if (result) {
                                   
                                   NSLog(@"uid = %@",[userInfo uid]);
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   NSLog(@"gender = %ld",(long)[userInfo gender]);//0:男1:女2:未知
                                   [SVProgressHUD showSuccessWithStatus:@"授权成功！"];
                                   
                                   [self thirdLogin:loginType info:[userInfo uid] sex:[userInfo gender] headerImage:[userInfo profileImage] name:[userInfo nickname]];
                                   
                                   
                                   
                               } else {
                                   NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                   [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                               }
                               
                           }];
}





- (void)thirdLogin:(NSInteger)type info:(NSString *)externalKey sex:(NSInteger)sex headerImage:(NSString *)headerImage name:(NSString *)name;
{
    
    NSString *provider;
    
    switch (type) {
        case 6:
            provider = @"0";
            break;
        case 1:
            provider = @"2";
            break;
        case 22:
            provider = @"1";
            break;
        default:
            break;
    }
    
    NSDictionary *dic = @{@"clientVersion":VERSION,
                          @"loginDevice":@"2",
                          @"registKey":@"",
                          @"thirdKey":externalKey,
                          @"thirdType":provider};

    [RequestManager PostUrl:URI_LOGIN_THIRDLOGIN loding:@"登录中..." dic:dic isToken:NO response:^(id response) {
       if ([response[@"ReturnCode"] integerValue] == 0) {
           //三方调到注册第二步
           RegisteredNextViewController *registeredNext = [[RegisteredNextViewController alloc] init];
           registeredNext.isRegistered = YES;
           registeredNext.thirdKey = externalKey;
           registeredNext.sexValue = sex + 1;
           registeredNext.thirdProvider = provider;
           registeredNext.thirdName = name;
           registeredNext.thirdHeaderImage = headerImage;
           [self.navigationController pushViewController:registeredNext animated:YES];
           [SVProgressHUD showSuccessWithStatus:@"请先注册"];
       }else if ([response[@"ReturnCode"] integerValue] == 3){
           
           //记录登陆模式 三方登陆
           [[NSUserDefaults standardUserDefaults] setObject:@"thirdLogin" forKey:@"isThirdWithPhoneLogin"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           //保存用户信息到本地
           [self saveUserInformation:response[@"ReturnData"]];
           //通知进入主页
           [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
           [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
       }else{
           [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
       }
       
   }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        RootBarController *rootBar = [[RootBarController alloc] init];
//        [self.navigationController pushViewController:rootBar animated:YES];
//    });
    
   
//清除三方登录信息
//            [UserData ClearUserDefaults:@"profileImage"];
//            [UserData ClearUserDefaults:@"nickname"];
    
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
@end
