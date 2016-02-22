//
//  NSString+FSExtension.m
//  FSCalendar
//
//  Created by Wenchao Ding on 8/29/15.
//  Copyright (c) 2015 wenchaoios. All rights reserved.
//

#import "NSString+FSExtension.h"

@implementation NSString (FSExtension)

- (NSDate *)fs_dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:self];
}

- (NSDate *)fs_date
{
    return [self fs_dateWithFormat:@"yyyyMMdd"];
}

+ (NSInteger)secondsWithString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    
    return (([array[0] integerValue] * 3600) + ([array[1] integerValue] * 60) + ([array[2] integerValue]));
}

+ (NSString *)stringWithSeconds:(NSInteger)seconds isHours:(BOOL)isHours
{
    
    NSString *minute = [NSString stringWithFormat:@"%02ld",(seconds % 3600) / 60];
    NSString *time = [NSString stringWithFormat:@"%02ld",seconds % 60];
    
    if (isHours == YES) {
        NSString *hour = [NSString stringWithFormat:@"%02ld",seconds / 3600];
        return [NSString stringWithFormat:@"%@ : %@ : %@",hour,minute,time];
    }else{
        return [NSString stringWithFormat:@"%@ : %@",minute,time];
    }
    
}

@end
