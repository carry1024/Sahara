//
//  RunViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunViewController.h"
#import "RunSongViewController.h"
#import "RootBarController.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>

@interface RunViewController ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *recentLabel;
@property (strong, nonatomic) IBOutlet UILabel *weekRecentLabel;
@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) IBOutlet UIImageView *playImageView;
@property (strong, nonatomic) MAMapView *mapView;
@end

@implementation RunViewController

#pragma mark -- 系统方法

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadRunData];
    ((RootBarController *)self.tabBarController).rootBarView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.showsUserLocation = NO;
    
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRunData) name:KNOTIFICATION_RUNRELOADDATA object:nil];
}

-(void)viewDidLayoutSubviews {
    
    _playImageView.layer.cornerRadius = _playImageView.bounds.size.height/2;
    _playImageView.layer.shadowOpacity = 0.5;
    _playImageView.layer.shadowColor = MAINCOLOR.CGColor;
}
- (void)loadRunData
{
    [RequestManager PostUrl:URI_RUN_MOVEMENTGETINDEX loding:nil dic:nil
                    isToken:YES response:^(id response)
     {
         if ([response[@"ReturnCode"] integerValue] == 3) {
             _recentLabel.text = [NSString stringWithFormat:@"%.2f",[response[@"ReturnData"][@"lastDistance"] floatValue]];
             _weekRecentLabel.text = [NSString stringWithFormat:@"%.2f",[response[@"ReturnData"][@"weekDistance"] floatValue]];
             _allLabel.text = [NSString stringWithFormat:@"%.2f",[response[@"ReturnData"][@"globalDistance"] floatValue]];
         }
     }];
    
}

- (IBAction)songTapAction:(UITapGestureRecognizer *)sender {
    //kCLAuthorizationStatusNotDetermined 用户对定位未做出了选择
    //kCLAuthorizationStatusRestricted    这个应用程序未被授权使用定位服务
    //kCLAuthorizationStatusDenied        对于这个应用程序,用户已经明确拒绝授权
    //kCLAuthorizationStatusAuthorizedAlways 用户获得授权使用其位置在任何时候
    //kCLAuthorizationStatusAuthorizedWhenInUse 用户获得授权使用他们的位置只有当应用程序在使用时
    
    CLAuthorizationStatus status    = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusNotDetermined) {
    _mapView                        = [[MAMapView alloc] init];
    _mapView.showsUserLocation      = YES;

    }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
    UIAlertView *alertView          = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请打开系统设置中“隐私→定位服务”，允许“撒哈拉”使用你的位置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"定位服务",nil];
        [alertView show];

    }else{
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // something
            RunSongViewController * runSong = [[RunSongViewController alloc]initWithNibName:@"RunSongViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:runSong animated:YES];
       
        });
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }

    }
    
}


@end
