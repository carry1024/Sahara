//
//  FindPwNextViewController.m
//  Sahara
//
//  Created by heng on 15/12/8.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FindPwNextViewController.h"
#import "JKCountDownButton.h"
#import "LoginViewController.h"
@interface FindPwNextViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *verificationTextfield;//验证码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;//密码
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextfield;//确认密码
@property (weak, nonatomic) IBOutlet JKCountDownButton *verificationBtn;//验证码

@end

@implementation FindPwNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _verificationTextfield.delegate = self;
    _passwordTextfield.delegate = self;
    _againPasswordTextfield.delegate = self;
    _passwordTextfield.keyboardType = UIKeyboardTypeASCIICapable;
    _againPasswordTextfield.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入6-12位密码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _againPasswordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请确认输入密码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    _verificationTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入验证码" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    在这里面判断
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
//返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//验证码
- (IBAction)verificationAction:(JKCountDownButton *)sender {
    //网络请求
    [RequestManager PostUrl:URI_LOGIN_GETSMSCODE loding:nil  dic:@{@"codeType":@"2",@"phoneNo":_phoneStr} isToken:NO response:^(id response) {
        
        if ([response[@"ReturnCode"] integerValue] == 3) {
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
    //网络请求
}
//确定
- (IBAction)determineAction:(UIButton *)sender {
    if (_verificationTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证码为空"];
        return;
    }
    if (_verificationTextfield.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    if (_passwordTextfield.text.length == 0 ) {
        [SVProgressHUD showErrorWithStatus:@"密码为空"];
        return;
    }
    if (_passwordTextfield.text.length < 6 || _passwordTextfield.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
        return;
    }
    if ( _againPasswordTextfield.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"确认密码为空"];
        return;
    }
    if (![_passwordTextfield.text isEqualToString:_againPasswordTextfield.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码不相符,请重新输入"];
        return;
    }
    //网络请求
    [RequestManager PostUrl:URI_LOGIN_ResetPassword loding:nil dic:@{@"newPsw":_againPasswordTextfield.text,@"phoneNo":_phoneStr, @"validateCode" :_verificationTextfield.text} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:login animated:NO];
            });
            
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            return ;
        }
    }];
    //修改成功

}
//收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
