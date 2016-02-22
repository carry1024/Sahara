//
//  MyAccountViewController.m
//  Sahara
//
//  Created by heng on 15/12/17.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountTableViewCell.h"
#import "ChangePassword.h"
#import "BingPhone.h"
#import "LoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "RootBarController.h"
#import "WXApi.h"

#import <ShareSDK/ISSPlatformUser.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface MyAccountViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    ChangePassword *_change;
    BingPhone *_bingPhone;
    NSString *_QQ, *_weixin, *_xinlang;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *exitLogin;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameState = [[NSMutableArray alloc] init];
    _nameArray = @[@"手机", @"新浪微博", @"QQ", @"微信",  @"修改密码"];
    [self data];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _exitLogin.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addCustomNavBarTitle:@"我的账户" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    //初始化修改密码界面
    _change    = [[[NSBundle mainBundle]loadNibNamed:@"ChangePassword" owner:self options:nil]lastObject];
    _change.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //初始化绑定手机视图
    _bingPhone    = [[[NSBundle mainBundle]loadNibNamed:@"bingPhone" owner:self options:nil]lastObject];
    _bingPhone.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
//弹出修改密码通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"cancle" object:nil];
    [center addObserver:self selector:@selector(noticePhone:) name:@"canclePhoneView" object:nil];
}
- (void)data{
    //网络请求
    [RequestManager PostUrl:URI_My_ThirdIndex loding:@"加载中.." dic:nil isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"Sina"]] isEqualToString:@"0"]) {
                _xinlang = @"未绑定";
            }
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"Sina"]] isEqualToString:@"1"]) {
                _xinlang = @"已绑定";
            }
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"WeChat"]] isEqualToString:@"0"]) {
                _weixin = @"未绑定";
            }
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"WeChat"]] isEqualToString:@"1"]) {
                _weixin = @"已绑定";
            }
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"QQ"]] isEqualToString:@"0"]) {
                _QQ = @"未绑定";
            }
            if ([[NSString stringWithFormat:@"%@", response[@"ReturnData"][@"QQ"]] isEqualToString:@"1"]) {
                _QQ = @"已绑定";
            }
            _nameState = @[response[@"ReturnData"][@"PhoneNo"], _xinlang, _QQ, _weixin,  @""];
            [_tableView reloadData];
//            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
        }else{
//            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
        
    }];
}
- (void)notice:(NSNotification *)info{
    [_change removeFromSuperview];
}
- (void)noticePhone:(NSNotification *)info{
    [self data];
    [_bingPhone removeFromSuperview];
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", (unsigned long)_nameState.count);
    return _nameArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"MyAccountTableViewCell";
    MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyAccountTableViewCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = _nameArray[indexPath.row];
    if (_nameState.count != 0) {
        cell.phoneNUmber.text = _nameState[indexPath.row];
    }

    if ([WXApi isWXAppInstalled] == NO && indexPath.row == 3){
        cell.image.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_nameState.count == 0) {
        return;
    }
    //kmi
    if (indexPath.row == 0) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isThirdWithPhoneLogin"] isEqualToString:@"thirdLogin"]) {
                    _bingPhone.password.placeholder = @"输入6-12位登录密码";
            _bingPhone.title.text = @"绑定手机";
        }

        [self.view addSubview:_bingPhone];
        
    }if (indexPath.row == 1) {
        if ([_xinlang isEqualToString:@"未绑定"]) {
            [self bangXinlang];
        }if ([_xinlang isEqualToString:@"已绑定"]) {
            [SVProgressHUD showSuccessWithStatus:@"您已绑定新浪微博"];
        }
        
    }if (indexPath.row == 2) {
        if ([_QQ isEqualToString:@"未绑定"]) {
            [self bangQQ];
            
        }if ([_QQ isEqualToString:@"已绑定"]) {
            [SVProgressHUD showSuccessWithStatus:@"您已绑定QQ"];
        }
        
    }if (indexPath.row == 3) {
        if ([_weixin isEqualToString:@"已绑定"]) {
            [SVProgressHUD showSuccessWithStatus:@"您已绑定微信"];
            return;
        }
        if ([WXApi isWXAppInstalled] == NO){
            return;
        }
        else {
            [self bangWeixin];
        }
        
    }if (indexPath.row == 4) {
        if ([_nameState[0] isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请先绑定手机号"];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:_nameState[0] forKey:@"changePassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.view addSubview:_change];
    }
}
- (void)bangQQ{
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    //取消授权
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo,  id error) {
                               //返回回调
                               if (result) {
                                   [RequestManager PostUrl:URI_MY_BindThird loding:@"正在授权..." dic:@{@"thirdKey":[userInfo uid], @"thirdType":@"0"} isToken:YES response:^(id response) {
                                       if ([response[@"ReturnCode"] integerValue] == 3) {
                                           [self data];
                                           [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
                                       }
                                   
                                   }];
                               } else {
                                   NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                   [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                               }
                               
    }];
}
- (void)bangXinlang{
    
    //取消授权
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo,  id error) {
                               
                               //返回回调
                               if (result) {
                                   [SVProgressHUD showSuccessWithStatus:@"授权成功！"];
                                   
                                   [RequestManager PostUrl:URI_MY_BindThird loding:nil dic:@{@"thirdKey":[userInfo uid], @"thirdType":@"2"} isToken:YES response:^(id response) {
                                       if ([response[@"ReturnCode"] integerValue] == 3) {
                                           [self data];
                                           [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
                                       }
                                       
                                   }];
                                   
                               } else {
                                   NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                   [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                               }
                               
                           }];
}
- (void)bangWeixin{
    
    //取消授权
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id<ISSPlatformUser> userInfo,  id error) {
                               
                               //返回回调
                               if (result) {
                                   [SVProgressHUD showSuccessWithStatus:@"授权成功！"];
                                   
                                   [RequestManager PostUrl:URI_MY_BindThird loding:nil dic:@{@"thirdKey":[userInfo uid], @"thirdType":@"1"} isToken:YES response:^(id response) {
                                       if ([response[@"ReturnCode"] integerValue] == 3) {
                                           [self data];
                                           [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
                                       }
                                       
                                   }];
                                   
                               } else {
                                   NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                   [SVProgressHUD showErrorWithStatus:[error errorDescription]];
                               }
                               
                           }];
}

//退出登录
- (IBAction)exitLogin:(UIButton *)sender {
    [UserData ClearUserDefaults:@"Token"];
    [UserData ClearUserDefaults:@"PhoneNo"];
    [UserData ClearUserDefaults:@"thirdLogin"];
    [UserData ClearUserDefaults:@"phoneLogin"];
    //清除图片
    [[SDImageCache sharedImageCache] cleanDisk];
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    
}


@end
