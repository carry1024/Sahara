//
//  RBTOrderViewController.m
//  Sahara
//
//  Created by huangcan on 16/1/6.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "RBTOrderViewController.h"


@interface RBTOrderViewController ()
@property (strong, nonatomic) IBOutlet UITextField *verificationTextField;

@end

@implementation RBTOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavBarTitle:@"设置彩铃" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    
    [RequestManager PostUrl:URI_SONG_SONGUSERLOGIN loding:@"查询是否开通彩铃..." dic:@{@"phoneNo":_phoneNum} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            //查询歌曲费用
            [self loadSongDataMoney];
            
        } else if ([response[@"ReturnCode"] integerValue] == 0) {
            
            [SVProgressHUD showInfoWithStatus:@"对不起，您尚未开通彩铃功能，请开通彩铃功能后购买彩铃！"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
}
- (IBAction)verificationBtnAction:(UIButton *)sender {
    
    if (_verificationTextField.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [RequestManager PostUrl:URI_SONG_SONGTONESET
                     loding:@"购买中..."
                        dic:@{@"contentId":_songId,@"phoneNo":_phoneNum,@"validateCode":_verificationTextField.text}
                    isToken:NO
                   response:^(id response)
    {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            
           [SVProgressHUD showInfoWithStatus:response[@"ReturnMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
        
    }];
}

//获取歌曲费用
- (void)loadSongDataMoney {
    
    [RequestManager PostUrl:URI_SONG_SONGTONEINFO loding:nil dic:@{@"contentId":_songId,@"phoneNo":_phoneNum} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                            message:response[@"ReturnData"]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else {
        
        [RequestManager PostUrl:URI_SONG_SONGGETMIGUVALIDATECODE loding:@"正在请求验证码..." dic:@{@"phoneNo":_phoneNum} isToken:NO response:^(id response) {
            
            [SVProgressHUD showInfoWithStatus:response[@"ReturnMsg"]];
            
        }];
    }
}

@end
