//
//  UserData.m
//  Sahara
//
//  Created by Chen on 15/6/30.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "UserData.h"

@implementation UserData
+ (BOOL)UserLoginState
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_dic"])
    {
        return YES;
    }
    else return NO;
}

+ (void)cleanUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_dic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*

 */
+ (void)WriteUserInfo:(id)dic
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_dic"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_dic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)reWriteUserInfo:(NSString *)value ForKey:(NSString *)key {
    
    NSData *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_dic"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict setValue:value forKey:key];
    [UserData WriteUserInfo:dict];
}
/*

 
 */
+ (NSString *)keyForUser:(NSString *)key
{
    NSData *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_dic"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
    NSString *string  = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
    return string;
}


+ (NSDictionary *)authData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"auth"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"auth"];
    }
    return nil;
}

+ (NSString *)userId {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Id"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"Id"];
    }
    return nil;
}
/**
 *  缓存写入
 */
+ (void)UserDefaults:(NSString *)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  缓存读取
 */
+ (NSString *)UserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
/**
 *  缓存清除
 */
+ (void)ClearUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
