//
//  AppDelegate.m
//  Sahara
//
//  Created by huangcan on 15/12/1.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "RootBarController.h"
#import "LoginViewController.h"
#import "startPageViewController.h"
#import "Archive.h"

#import <ShareSDK/ShareSDK.h>

#import <WXApi.h>
#import <WeiboSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MobClick.h>
#import "FMDB_Help.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#pragma mark - 状态栏
    // info.plist ->添加字段"View controller-based status bar appearance" ->在appdelegate执行以下方法
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //通知跳转主界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //初始化三方
    [self status];
    
    [self.window makeKeyAndVisible];
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}


#pragma mark ---- 三方

- (void)status {
    //SQLit
    [FMDB_Help sharedInstance];
    //键盘
    [IQKeyboardManager sharedManager];
    //通知
    [self loginStateChange:nil];
    //提醒框
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    //修改提示框出现的BUG
    _window.tag = WindowTag;
    //shareSDK
    [self configurationShareSDK];
    //高德
    [self configurationMAMap];
    //友盟
    [self configurationMobClick];
    
    
}

#pragma mark 配置shareSDK

-(void)configurationShareSDK
{
    //1.初始化ShareSDK应用,字符串"iosv1101"是应该换成你申请的ShareSDK应用中的Appkey
    [ShareSDK registerApp:@"80f07f755170"];
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
}
- (void)initializePlat
{
    //连接短信分享
//    [ShareSDK connectSMS];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    
    [ShareSDK connectSinaWeiboWithAppKey:@"1428953287" appSecret:@"311e052eb4ce8043b9936d13a54c8667" redirectUri:@"http://sns.whalecloud.com/sina2/callback" weiboSDKCls:[WeiboSDK class]];
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104632559"
                           appSecret:@"ilroV8LCV9dZ2F2e"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104632559" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx7c322f6df50b574f"
                           appSecret:@"3145fe71eedf718113e01e8e710501cb"
                           wechatCls:[WXApi class]];
    
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:nil];
}

#pragma mark 配置高德地图

-(void)configurationMAMap {
    //    0fb8a1b124f5eaaa2f6504b89b068c85//com.JY.sahara
    //    9c371a2554aef23696cc8ecc31398e4b//com.bode.Sahara
    //高德地图
    [MAMapServices sharedServices].apiKey = @"0fb8a1b124f5eaaa2f6504b89b068c85";
    //高德定位
    [AMapLocationServices sharedServices].apiKey =@"0fb8a1b124f5eaaa2f6504b89b068c85";
}



#pragma mark 友盟

-(void)configurationMobClick {
    
    [MobClick startWithAppkey:@"55fbb99b67e58e3d8d00000c" reportPolicy:BATCH   channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
}

#pragma mark ---- 自定义方法

#pragma mark  通知跳转root控制器
-(void)loginStateChange:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"statrtPage"] == NO) {
        startPageViewController *startPage = [[startPageViewController alloc] init];
        self.window.rootViewController = startPage;
        return;
    }
    
    BOOL isAutoLogin = TOKEN ? YES:NO;
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess == YES || isAutoLogin == YES) {
        RootBarController *root = [[RootBarController alloc]init];
        UINavigationController *rootNav = [[UINavigationController alloc]initWithRootViewController:root];
        self.window.rootViewController = rootNav;
    }else{
        LoginViewController * login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UINavigationController * navLogin = [[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = navLogin;
    }
}

@end