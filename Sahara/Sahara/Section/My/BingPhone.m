//
//  BingPhone.m
//  Sahara
//
//  Created by heng on 15/12/18.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "BingPhone.h"
#import "JKCountDownButton.h"
@interface BingPhone ()<UITextFieldDelegate>
@end
@implementation BingPhone

-(void)awakeFromNib
{
    [super awakeFromNib];
    _password.secureTextEntry = YES;
    _phoneNumber.delegate = self;
    _password.delegate = self;
    _verificationNumber.delegate = self;
    [self addSubview:_view];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    在这里面判断
    if (range.location >= 12 && self.password == textField) {
        return NO;
    }
    if (range.location >= 11 && self.phoneNumber == textField) {
        return NO;
    }
    if (range.location >= 6 && self.verificationNumber == textField) {
        return NO;
    }
    return YES;
}
- (IBAction)cancle:(UIButton *)sender {
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"canclePhoneView" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

- (IBAction)sure:(UIButton *)sender {
    if (_phoneNumber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号为空"];
        return;
    }
    if (![_phoneNumber.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    if (_verificationNumber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证码为空"];
        return;
    }
    if (_verificationNumber.text.length != 6) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        return;
    }
    if (_password.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码为空"];
        return;
    }
    if (_password.text.length < 6 || _password.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
        return;
    }
   
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"thirdLogin"]) {
        //网络请求
        
        [RequestManager PostUrl:URI_MY_ValidateEditor loding:nil dic:@{@"phoneNo":_phoneNumber.text, @"password":_password.text,@"validateCode":_verificationNumber.text} isToken:YES response:^(id response) {
            
            if ([response[@"ReturnCode"] integerValue] == 3) {
                
                [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber.text forKey:@"PhoneNo"];
                [[NSUserDefaults standardUserDefaults] setObject:@"phoneLogin" forKey:@"isThirdWithPhoneLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            }
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //创建通知取消弹框
            NSNotification * notice = [NSNotification notificationWithName:@"canclePhoneView" object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            
        });
        return ;
        
    }if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"phoneLogin"]) {
        //网络请求
        
        [RequestManager PostUrl:URI_MY_ChangePasswordNo loding:nil dic:@{@"newPhoneNo":_phoneNumber.text, @"phoneNo":[[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNo"],@"password":_password.text,@"validateCode":_verificationNumber.text} isToken:YES response:^(id response) {
            
            if ([response[@"ReturnCode"] integerValue] == 3) {
                
                [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber.text forKey:@"PhoneNo"];
                
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //创建通知取消弹框
                NSNotification * notice = [NSNotification notificationWithName:@"canclePhoneView" object:nil userInfo:nil];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            });
        }];
        
    }
    
}
- (IBAction)getVerificationAction:(JKCountDownButton *)sender {
    if (_phoneNumber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号为空"];
        return;
    }
    if (![_phoneNumber.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    //网络请求
    NSString  *number;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"thirdLogin"]) {
        number = @"0";
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"phoneLogin"]) {
        number = @"3";
    }
    
    [RequestManager PostUrl:URI_LOGIN_GETSMSCODE loding:nil  dic:@{@"codeType":number,@"phoneNo":_phoneNumber.text} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
    }];
    sender.enabled = NO;
    [sender setBackgroundImage:[UIImage imageNamed:@"My_获取验证码"] forState:UIControlStateNormal];
    [sender startWithSecond:60];
    [sender didChange:^NSString *(JKCountDownButton *countDownButton, int second) {
        NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        sender.enabled = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"My_获取验证码"] forState:UIControlStateNormal];
        return @"重新获取";
    }];
    //网络请求
    
}




@end
