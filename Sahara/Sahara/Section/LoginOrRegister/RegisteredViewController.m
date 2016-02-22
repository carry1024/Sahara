//
//  RegisteredViewController.m
//  Sahara
//
//  Created by heng on 15/12/7.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RegisteredViewController.h"
#import "JKCountDownButton.h"
#import "RegisteredNextViewController.h"
#import "AgreeMentViewController.h"
@interface RegisteredViewController ()<UITextFieldDelegate>{
    NSString *_verification;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;//电话

@property (weak, nonatomic) IBOutlet UITextField *verificationTextfield;//验证码

@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;//密码
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextfield;//重复密码
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册按钮
@property (weak, nonatomic) IBOutlet JKCountDownButton *verificationBtn;//验证码按钮

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNumberTextfield.delegate = self;
    _verificationTextfield.delegate = self;
    _passwordTextfield.delegate = self;
    _againPasswordTextfield.delegate = self;
    _phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入11位手机号" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _verificationTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入验证码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入6-12位密码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _againPasswordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请确认登陆密码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    在这里面判断
    if (range.location >= 11 && self.phoneNumberTextfield == textField) {
        return NO;
    }
    if (range.location >= 6 && self.verificationTextfield == textField) {
        return NO;
    }
    if (range.location >= 12 && self.passwordTextfield == textField) {
        return NO;
    }
    if (range.location >= 12 && self.againPasswordTextfield == textField) {
        return NO;
    }
    return YES;
}

- (IBAction)userAgreementAction:(UITapGestureRecognizer *)sender {
    AgreeMentViewController *vc = [[AgreeMentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//注册按钮点击
- (IBAction)registeredAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (_phoneNumberTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号为空"];
        return;
    }
    if (![_phoneNumberTextfield.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (_verificationTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证码为空"];
        return;
    }
    if (_verificationTextfield.text.length != 6 || ![_verificationTextfield.text isEqualToString:_verification]) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    if (_passwordTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码为空"];
        return;
    }
    if (_passwordTextfield.text.length < 6 || _passwordTextfield.text.length > 12 ) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
        return;
    }
    if (_againPasswordTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"确认密码为空"];
        return;
    }
    
    if (![_passwordTextfield.text isEqualToString:_againPasswordTextfield.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码不相符，请重新输入"];
        return;
    }
    
    RegisteredNextViewController *Register = [[RegisteredNextViewController alloc] initWithNibName:@"RegisteredNextViewController" bundle:[NSBundle mainBundle]];
    Register.phoneNumber  = _phoneNumberTextfield.text;
    Register.verification = _verificationTextfield.text;
    Register.password     = _passwordTextfield.text;

    [self.navigationController pushViewController:Register animated:YES];

    
}
//发送验证码、倒计时
- (IBAction)verificationAction:(JKCountDownButton *)sender {
    
    if ([_phoneNumberTextfield.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号！"];
        return;
    }
    
    if (![_phoneNumberTextfield.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    
    //网络请求
    [RequestManager PostUrl:URI_LOGIN_GETSMSCODE loding:nil dic:@{@"codeType":@"1",@"phoneNo":_phoneNumberTextfield.text} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            _verification = response[@"ReturnData"];
            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
    }];
    
    
    
    
    sender.enabled = NO;
    [sender startWithSecond:60];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        sender.enabled = YES;
        return @"重新获取";
    }];
    
}
//返回上一页
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
