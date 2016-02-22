//
//  ForgotViewController.m
//  Sahara
//
//  Created by heng on 15/12/8.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ForgotViewController.h"
#import "FindPwNextViewController.h"
@interface ForgotViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNUmber;

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNUmber.delegate = self;
    _phoneNUmber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入11位手机号" attributes:@{NSForegroundColorAttributeName: PLACECOLOR}];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //    在这里面判断
    if (range.location >= 11 && self.phoneNUmber == textField) {
        return NO;
    }
    return YES;
}

- (IBAction)nextAction:(UIButton *)sender {
    if (_phoneNUmber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (![_phoneNUmber.text isPhoneNumber]) {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        return;
    }
    //网络请求
    FindPwNextViewController *forgotNext = [[FindPwNextViewController alloc] initWithNibName:@"FindPwNextViewController" bundle:[NSBundle mainBundle]];
    forgotNext.phoneStr = _phoneNUmber.text;
    [self.navigationController pushViewController:forgotNext animated:YES];
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


@end
