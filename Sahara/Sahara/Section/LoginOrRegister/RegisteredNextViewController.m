//
//  RegisteredNextViewController.m
//  Sahara
//
//  Created by heng on 15/12/8.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RegisteredNextViewController.h"
#import "CustomPickerview.h"


@interface RegisteredNextViewController (){
    int _unitLogo;//体重、身高单位标志
}
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *heightBtn;

@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *sex;

@end

@implementation RegisteredNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Sex:1.男2.女
    if (_sexValue == 2) {
        _sex = @"2";
        _womanButton.selected = YES;
        self.currentButton = _womanButton;
    }else{
        _sex = @"1";
        _maleButton.selected = YES;
        self.currentButton = _maleButton;
    }
    
    
}

//返回
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//男
- (IBAction)men:(UIButton *)sender {
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
    _sex = @"1";
}
//女
- (IBAction)women:(UIButton *)sender {
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
    _sex = @"2";
}
//体重、身高
- (IBAction)weight:(UIButton *)sender {
    //体重
    CustomPickerview *picker    = [[[NSBundle mainBundle]loadNibNamed:@"CustomPickerview" owner:self options:nil]lastObject];
    picker.frame                = [[UIScreen mainScreen]bounds];
    pickerType type;
    
    if (sender.tag == 100) {
        _unitLogo = 1;
        type = pickerType_weight;
//        [picker.pickerview selectRow:30 inComponent:0 animated:NO];
    }
    else if (sender.tag == 101) {
        _unitLogo = 0;
        type = pickerType_height;
//        [picker.pickerview selectRow:110 inComponent:0 animated:NO];
    }
    else if (sender.tag == 102) {
        type = pickerType_score;
    }
    picker.pickerType           = type;
    [picker setRequestFinishBlock:^(NSString *str)
     {
         if (_unitLogo == 1) {
             NSString *unit = [NSString stringWithFormat:@"%@ kg", str];
             [sender setTitle:unit forState:UIControlStateNormal];
             _weight = str;
         }if (_unitLogo == 0) {
             NSString *unit = [NSString stringWithFormat:@"%@ cm", str];
             [sender setTitle:unit forState:UIControlStateNormal];
             _height = str;
         }
         
         
     }];
    [[self.view window] addSubview:picker];
}

//确定
- (IBAction)sure:(UIButton *)sender {
    if (self.weightBtn.titleLabel.text.length > 0 && self.heightBtn.titleLabel.text.length > 0) {
        
        NSString *URL;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:_height forKey:@"Height"];
        [dic setObject:_weight forKey:@"Weight"];
        [dic setObject:_sex forKey:@"Sex"];
        
        
        if (_isRegistered) {
            //三方注册
            [dic setObject:@"2" forKey:@"LoginDevice"];
            [dic setObject:VERSION forKey:@"clientVersion"];
            [dic setObject:@"" forKey:@"registkey"];
            [dic setObject:_thirdKey forKey:@"thirdKey"];
            [dic setObject:_thirdProvider forKey:@"thirdProvider"];
            [dic setObject:_thirdName forKey:@"NickName"];
            [dic setObject:_thirdHeaderImage forKey:@"HeadPic"];
            URL = URI_LOGIN_THIRDREGISTER;
        }else{
            //用户登录
            [dic setValue:_phoneNumber forKey:@"PhoneNo"];
            [dic setValue:_verification forKey:@"validateCode"];
            [dic setValue:_password forKey:@"Password"];
            URL = URI_LOGIN_REGISTER;
        }
       
        //网络请求
        [RequestManager PostUrl:URL loding:@"注册中..." dic:dic isToken:NO response:^(id response) {
            if ([response[@"ReturnCode"] integerValue] == 3) {
                [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                if (_isRegistered) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"thirdLogin" forKey:@"isThirdWithPhoneLogin"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //保存用户信息到本地
                    [self saveUserInformation:response[@"ReturnData"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"phoneLogin" forKey:@"isThirdWithPhoneLogin"];
//                    [self saveUserInformation:response[@"ReturnData"]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            }
            
        }];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"请输入相关信息!"];
    }
    
    

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
