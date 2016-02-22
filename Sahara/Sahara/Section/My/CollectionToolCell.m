//
//  CollectionToolCell.m
//  Sahara
//
//  Created by heng on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "CollectionToolCell.h"
#import "RBTOrderViewController.h"
#import "MyAccountViewController.h"
#import "UIView+Extension.h"
@implementation CollectionToolCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//设为彩铃
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyAccountViewController * account = [[MyAccountViewController alloc]initWithNibName:@"MyAccountViewController" bundle:[NSBundle mainBundle]];
                [self.myViewController.navigationController pushViewController:account animated:YES];
            });
        }
    });
    
}
//删除
- (IBAction)deleteBtnAction:(UIButton *)sender {
    
    NSIndexPath * indexPath = objc_getAssociatedObject(sender,"indexPath");
    
    NSNotification * notice = [NSNotification notificationWithName:@"delede" object:nil userInfo:@{@"songId":_songId,@"indexPath":indexPath}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    /*
    [RequestManager PostUrl:URI_RUN_SONGDELSONGLIKE loding:@"正在删除..." dic:@{@"contentId":_songId} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];

            
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
     */
}

@end
