//
//  ShareCustom.m
//  Sahara
//
//  Created by huangcan on 16/1/20.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "ShareCustom.h"
#import <ShareSDK/ShareSDK.h>
//设备物理大小
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
@implementation ShareCustom

static id _publishContent;//类方法中的全局变量这样用（类型前面加static）
static id _woboPublishContent;
/*
 自定义的分享类，使用的是类方法，其他地方只要 构造分享内容publishContent就行了
 */

+(void)shareWithContent:(id)publishContent woboContent:(id)woboPublishContent/*只需要在分享按钮事件中 构建好分享内容publishContent传过来就好了*/
{
    _publishContent = publishContent;
    _woboPublishContent = woboPublishContent;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    blackView.backgroundColor = RGBA(0, 0, 0, 0.5);
    blackView.tag = 440;
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 240,kScreenWidth,240)];
    shareView.backgroundColor = RGBA(246,246,246, 1);
    shareView.layer.masksToBounds =YES;
    shareView.tag = 441;
    [window addSubview:shareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, shareView.frame.size.width, 45*KWidth_Scale)];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15*KWidth_Scale];
    titleLabel.textColor = RGBA(42,42,42, 1);
    titleLabel.backgroundColor = [UIColor clearColor];
    [shareView addSubview:titleLabel];
    
    NSArray *btnImages = @[@"My_微信", @"My_朋友圈", @"My_QQ", @"My_微博"];
    NSArray *btnTitles = @[@"微信好友", @"微信朋友圈", @"QQ好友",@"新浪微博"];
    for (NSInteger i=0; i<4; i++) {
        CGFloat top = 0.0f;
        if (i<4) {
            top = 10*KWidth_Scale;
            
        }else{
            top = 90*KWidth_Scale;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10*KWidth_Scale+(i%4)*80*KWidth_Scale, titleLabel.frame.origin.y+titleLabel.frame.size.height + top, 100*KWidth_Scale, 100*KWidth_Scale)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        [button setTitle:btnTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11*KWidth_Scale];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:RGBA(42,42,42, 1) forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 30*KWidth_Scale, 45*KWidth_Scale, 15*KWidth_Scale)];
        if (SYSTEM_VERSION >= 8.0f) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(60*KWidth_Scale, -40*KWidth_Scale, 5*KWidth_Scale, 0)];
        }else{
            [button setTitleEdgeInsets:UIEdgeInsetsMake(45*KWidth_Scale, -90*KWidth_Scale, 5*KWidth_Scale, 0)];
        }
        
        button.tag = 331+i;
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:button];
    }
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake((shareView.frame.size.width-100*KWidth_Scale)/2.0f, shareView.frame.size.height-40*KWidth_Scale-18*KWidth_Scale, 100*KWidth_Scale, 40*KWidth_Scale)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:RGBA(42,42,42, 1) forState:UIControlStateNormal];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"login_register_重新获取框"] forState:UIControlStateNormal];
    cancleBtn.tag = 500;
    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.frame = CGRectMake(0, kScreenHeight,kScreenWidth,240);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0,kScreenHeight - 240,kScreenWidth,240);
    } completion:^(BOOL finished) {
        
    }];
}

+(void)shareBtnClick:(UIButton *)btn
{
    //    NSLog(@"%@",[ShareSDK version]);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    shareView.frame = CGRectMake(0,kScreenHeight - 240,kScreenWidth,240);
    [UIView animateWithDuration:0.35f animations:^{
        shareView.frame = CGRectMake(0, kScreenHeight,kScreenWidth,240);
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    
    int shareType = 0;
    id publishContent = _publishContent;
    switch (btn.tag) {
        case 331:
        {
            shareType = ShareTypeWeixiSession;
        }
            break;
            
        case 332:
        {
            shareType = ShareTypeWeixiTimeline;
        }
            break;
            
        case 333:
        {
            shareType = ShareTypeQQ;
        }
            break;
            
        case 334:
        {
            shareType = ShareTypeSinaWeibo;
            publishContent = _woboPublishContent;
        }
            break;
        case 500:
        {
            
        }
        default:
            break;
    }
    
    /*
     调用shareSDK的无UI分享类型，
     链接地址：http://bbs.mob.com/forum.php?mod=viewthread&tid=110&extra=page%3D1%26filter%3Dtypeid%26typeid%3D34
     */
    [ShareSDK showShareViewWithType:shareType container:nil content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id statusInfo, id error, BOOL end) {
        if (state == SSResponseStateSuccess)
        {
            //            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
        }
        else if (state == SSResponseStateFail)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未检测到客户端 分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
        }
    }];
    
    
    
}
@end

