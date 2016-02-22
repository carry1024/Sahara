//
//  Conf.h
//  zhiquan
//
//  Created by huangcan on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#ifndef zhiquan_Conf_h
#define zhiquan_Conf_h

#pragma mark - 常用  ------------ ------------ ------------ ------------ ------------ ------------
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define ENCODEING   NSUTF8StringEncoding  //系统环境使用的编码

#define  PHONEBOUNDS [UIScreen mainScreen].bounds;

#pragma mark - UserDefaults  ------------ ------------ ------------ ------------ ------------

//用户ID
#define USERID          [DataDefaults getStringForKey:@"UserId"]


#pragma mark - 接口地址 ------------ ------------ ------------ ------------ ------------ ------------

/**
 *分享地址
 */
#define SHAREURL @"http://www.sahara195.com/Share/Index"




#define HOMEURL  @"http://120.24.184.179:8025/Api/"

#define URI_API(url) [HOMEURL stringByAppendingString:url]


/**
 *跑步界面首页
 */
#define URI_RUN_MOVEMENTGETINDEX       URI_API(@"Movement/GetIndex")
/**
 *注册登陆：登陆
 */
#define URI_LOGIN_LOGIN             URI_API(@"Account/Login")

/**
 *注册登陆：获取短信验证码
 */
#define URI_LOGIN_GETSMSCODE        URI_API(@"Account/GetSmsCode")

/**
 *注册登陆：用户注册
 */
#define URI_LOGIN_REGISTER          URI_API(@"Account/ValidateRegister")

/**
 *注册登陆：第三方登陆
 */
#define URI_LOGIN_THIRDLOGIN        URI_API(@"Account/ThirdLogin")

/**
 *注册登陆：第三方注册
 */
#define URI_LOGIN_THIRDREGISTER   URI_API(@"/Account/ThirdRegister")

/**
 *获取个人信息
 */
#define URI_My_GetUserInfo           URI_API(@"Account/GetUserInfo")
/**
 *用户首页
 */
#define URI_My_AccocuntIndex           URI_API(@"Account/AccountIndex")
/**
 *用编辑用户信息
 */
#define URI_My_EditUserInfo          URI_API(@"Account/EditUserInfo")
/**
 *我的账户页面接口
 */
#define URI_My_ThirdIndex          URI_API(@"Account/ThirdIndex")
/**
 *意见反馈
 */
#define URI_My_AddFeedBack          URI_API(@"Account/AddFeedBack")
/**
 *重置密码
 */
#define URI_LOGIN_ResetPassword           URI_API(@"Account/ResetPassword")
/**
 *修改密码
 */
#define URI_MY_ChangePassword           URI_API(@"Account/ChangePassword")
/**
 *修改手机号
 */
#define URI_MY_ChangePasswordNo           URI_API(@"account/ChangePhoneNo")
/**
 *三方绑定手机号
 */
#define URI_MY_ValidateEditor           URI_API(@"Account/ValidateEditor")
/**
 *绑定三方账号
 */
#define URI_MY_BindThird           URI_API(@"/Account/BindThird")
/**
 * 跑步记录
 */
#define URI_RUN_GetRunList            URI_API(@"Movement/GetRunList")
/**
 * 跑步详情
 */
#define URI_RUN_GetRunDetails            URI_API(@"Movement/GetRunDetails")
/**
 * 跑步歌单
 */
#define URI_RUN_GETPLAYLISTS            URI_API(@"song/GetPlayLists")
/**
 * 跑步歌曲
 */
#define URI_RUN_GETSONGLISTBYPLAYID     URI_API(@"song/GetSongListByPlayId")
/**
 * 我的收藏
 */
#define URI_RUN_GetMyFavorite         URI_API(@"song/GetMyFavorite")

/**
 * 添加收藏
 */
#define URI_RUN_ADDSONGLIKE         URI_API(@"song/AddSongLike")
/**
 * 取消收藏
 */
#define URI_RUN_SONGDELSONGLIKE     URI_API(@"song/DelSongLike")
/**
 * 推送跑步数据
 */
#define URI_RUN_MOVEMENTPUSHRUNDATA                   URI_API(@"Movement/PushRunData")
/**
 * 获取活动
 */
#define URI_RUN_ARTICLEGETACTITYLIST                  URI_API(@"Article/GetActityList")
/**
 * 获取活动需要填写的资料
 */
#define URI_ACTIVITY_ARTIVLEGETELEMENT                URI_API(@"Article/GetElement")
/**
 * 提交参加活动数据
 */
#define URI_ACTIVITY_ARTICLEJOINACTIVITY              URI_API(@"Article/JoinActivity")
/**
 * 获取用户是否开通彩铃服务
 */
#define URI_SONG_SONGUSERLOGIN                        URI_API(@"song/UserLogin")
/**
 * 获取彩铃订购扣费信息
 */
#define URI_SONG_SONGTONEINFO                         URI_API(@"song/ToneInfo")
/**
 * 购买彩铃
 */
#define URI_SONG_SONGTONESET                          URI_API(@"song/ToneSet")
/**
 * 获取咪咕验证码
 */
#define URI_SONG_SONGGETMIGUVALIDATECODE              URI_API(@"song/GetMiGuValidateCode")



#define URI_UPPIC(url) [UPPiCURL stringByAppendingString:url]
#define URI_UPLOADPIC                               URI_UPPIC(@"Upload/UploadPic")


//归档路径
#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject


#pragma mark -  通知 ------------ ------------ ------------ ------------ ------------ ------------

#define KNOTIFICATION_LOGINCHANGE  @"loginStateChange"
#define KNOTIFICATION_RUNRELOADDATA @"runReloadData"
#define KNOTIFICATION_SONGRESTART @"songRestart"
#define KNOTIFICATION_SONGEND     @"songEnd"
#endif
