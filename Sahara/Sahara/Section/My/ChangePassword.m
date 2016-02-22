//
//  ChangePassword.m
//  Sahara
//
//  Created by heng on 15/12/18.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ChangePassword.h"
#import "JKCountDownButton.h"
@interface ChangePassword ()<UITextFieldDelegate>
@end
@implementation ChangePassword
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.oldPasswordWH.secureTextEntry = YES;
    self.oldPasswordWH.delegate = self;
    self.newerPasswordWH.secureTextEntry = YES;
    self.newerPasswordWH.delegate = self;
    self.onceNewPassword.secureTextEntry = YES;
    self.onceNewPassword.delegate =self;
    [self addSubview:_view];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    在这里面判断
    if (range.location >= 12 && self.oldPasswordWH == textField) {
        return NO;
    }
    if (range.location >= 12 && self.newerPasswordWH == textField) {
        return NO;
    }
    if (range.location >= 12 && self.onceNewPassword == textField) {
        return NO;
    }
    return YES;
}


- (IBAction)sureAction:(UIButton *)sender {
    if (_oldPasswordWH.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"旧密码为空"];
        return;
    }
    if (_oldPasswordWH.text.length < 6 || _oldPasswordWH.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"旧密码错误"];
        return;
    }
    if (_newerPasswordWH.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"新密码为空"];
        return;
    }
    if (_newerPasswordWH.text.length < 6 || _newerPasswordWH.text.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"请输入6-12位新密码"];
        return;
    }
    if (![_newerPasswordWH.text isEqualToString:_onceNewPassword.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码不相符,请重新输入"];
        return;
    }
//        //网络请求
        [RequestManager PostUrl:URI_MY_ChangePassword loding:nil dic:@{@"phoneNo":[[NSUserDefaults standardUserDefaults] objectForKey:@"changePassword"] ,@"newPsw":_newerPasswordWH.text,@"oldPsw":_oldPasswordWH.text} isToken:YES response:^(id response) {
            
            if ([response[@"ReturnCode"] integerValue] == 3) {
                
                [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            }
            
        }];
        
        //创建通知取消弹框
        NSNotification * notice = [NSNotification notificationWithName:@"cancle" object:nil userInfo:nil];
        //发送消息
        [[NSNotificationCenter defaultCenter]postNotification:notice];
//    }
}
- (IBAction)cancleAction:(UIButton *)sender {
    
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"cancle" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}

@end
