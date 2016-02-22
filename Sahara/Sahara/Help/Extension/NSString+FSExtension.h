//
//  NSString+FSExtension.h
//  FSCalendar
//
//  Created by Wenchao Ding on 8/29/15.
//  Copyright (c) 2015 wenchaoios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FSExtension)

- (NSDate *)fs_dateWithFormat:(NSString *)format;
- (NSDate *)fs_date;

/**
 *时间转化成秒
 */
+ (NSInteger)secondsWithString:(NSString *)string;


/**
 *秒转化成时间  00 : 00 : 00
 */
/**
 *  秒转化成时间
 *
 *  @param seconds 传入的秒数
 *  @param isHours YES表示小时（00 : 00 : 00）  NO表示分钟（00 : 00）
 *
 *  @return 返回时间字符串
 */
+ (NSString *)stringWithSeconds:(NSInteger)seconds isHours:(BOOL)isHours;

@end
