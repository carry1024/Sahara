//
//  GroupChatDataCell.m
//  兜捞
//
//  Created by doulao ios1 on 14-11-12.
//  Copyright (c) 2014年 doulao ios1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface NSString (ESUN)

- (NSString *)UTCTimeString;

- (NSString *)dateString;//获得时间
/**
 *  @brief  .NET时间戳
 */
- (NSString *)dateStringForNet;
/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isPhoneNumber;
//与当前时间之差
-(NSString *)timeBetweenNow;
//获取字符串高宽
- (CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size;
@end
