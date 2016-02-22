//
//  BingPhone.h
//  Sahara
//
//  Created by heng on 15/12/18.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BingPhone : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verificationNumber;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property(nonatomic, strong)NSString *oldPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *title;


@end
