//
//  ChangePassword.h
//  Sahara
//
//  Created by heng on 15/12/18.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassword : UIView
//@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
//@property (weak, nonatomic) IBOutlet UITextField *verificationNumber;//新密码
//@property (weak, nonatomic) IBOutlet UITextField *password;//旧密码
@property (weak, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordWH;
@property (strong, nonatomic) IBOutlet UITextField *newerPasswordWH;

@property (strong, nonatomic) IBOutlet UITextField *onceNewPassword;



@end
