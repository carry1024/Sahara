//
//  SongToolCell.m
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "SongToolCell.h"
#import "RBTOrderViewController.h"
#import "MyAccountViewController.h"

@implementation SongToolCell

- (void)loadCellDic:(NSDictionary *)dic {
    
    _collectionBtn.selected = [dic[@"like"] boolValue];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)RBTBtnAction:(UIButton *)sender {
    DLog(@"彩铃");
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        //是否绑定手机
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"phoneLogin"]) {
            
            NSString * phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNo"];
            RBTOrderViewController * RBTorder = [[RBTOrderViewController alloc]initWithNibName:@"RBTOrderViewController" bundle:[NSBundle mainBundle]];
            RBTorder.songId = _songId;
            RBTorder.phoneNum = phone;
            [self.myViewController.navigationController pushViewController:RBTorder animated:YES];
        } else {
            
            [SVProgressHUD showInfoWithStatus:@"请绑定手机号"];
            
            MyAccountViewController * account = [[MyAccountViewController alloc]initWithNibName:@"MyAccountViewController" bundle:[NSBundle mainBundle]];
            [self.myViewController.navigationController pushViewController:account animated:YES];
        }
    });
}
- (IBAction)collectionBtnAction:(UIButton *)sender {
    
    NSString * url = nil;
    NSString * loding = nil;
    if (sender.selected == YES) {
        url = URI_RUN_SONGDELSONGLIKE;
        loding = @"取消收藏...";
    } else {
        url = URI_RUN_ADDSONGLIKE;
        loding = @"添加收藏...";
    }
    [RequestManager PostUrl:url loding:loding dic:@{@"contentId":_songId} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            sender.selected = !sender.selected;
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            // 主线程执行：
            dispatch_async(dispatch_get_main_queue(), ^{
                // something
                [self.delegate toolCellCollection:sender];
            });
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
}

//获取父控制器
- (UIViewController*)myViewController {
    id target = self;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            return target;
        }
    }
    return nil;
}

@end
