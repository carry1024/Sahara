//
//  UserData.h
//  Sahara
//
//  Created by Chen on 15/6/30.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject
+ (BOOL)UserLoginState;
+ (void)WriteUserInfo:(id)dic;
//更改用户信息
+ (void)reWriteUserInfo:(NSString *)value ForKey:(NSString *)key;
//
+ (NSString *)keyForUser:(NSString *)key;
//
+ (void)cleanUserInfo;


+ (NSDictionary *)authData;

+ (NSString *)userId;
/**
 *  缓存写入
 */
+ (void)UserDefaults:(NSString *)value key:(NSString *)key;
/**
 *  缓存读取
 */
+ (NSString *)UserDefaults:(NSString *)key;
/**
 *  缓存清除
 */
+ (void)ClearUserDefaults:(NSString *)key;
@end
