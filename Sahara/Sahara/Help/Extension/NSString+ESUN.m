//
//  GroupChatDataCell.m
//  兜捞
//
//  Created by doulao ios1 on 14-11-12.
//  Copyright (c) 2014年 doulao ios1. All rights reserved.
//

#import "NSString+ESUN.h"

@implementation NSString (ESUN)
//
- (NSString *)UTCTimeString {
    NSString *time = self;
    if (self) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDate *date = [dateFormat dateFromString:time];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        time = [dateFormat stringFromDate:date];
    }
    return time;
}



- (NSString *)dateString
{
    NSString *time = self;
    if(self)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        time = [dateFormat stringFromDate:date];
    }
    return time;
}

//.NET数据类型
- (NSString *)dateStringForNet
{
    NSString *time = self;
    if(self)
    {
        time = [time stringByReplacingOccurrencesOfString:@"/Date(" withString:@""];
        time = [time stringByReplacingOccurrencesOfString:@")/" withString:@""];
        CGFloat timeFloat = [time floatValue];
        NSString *NewString = [NSString stringWithFormat:@"%.f",timeFloat / 1000];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NewString intValue]];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        time = [dateFormat stringFromDate:date];
    }
    return time;
}


/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isPhoneNumber
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    //@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,152,155,156,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,180,189
     22 */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}
//与当前时间之差
-(NSString *)timeBetweenNow
{
    NSString *nowDate = self;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[nowDate longLongValue] / 1000];
    
    
    NSDate* current_date = [NSDate date];
    
    NSTimeInterval time = [current_date timeIntervalSinceDate:date];//间隔的秒数
    int month  = ((int)time)/(3600*24*30);
    int days   =  ((int)time)/(3600*24);
    int hours  = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/60;
    
    NSString *dateContent;
    
    if(month!=0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        dateContent = [dateFormatter stringFromDate:date];
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        
    }else if(days!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天前"];
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时前"];
    }else {
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
    }
    
    //    NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return dateContent;
}
//获取字符串高宽
- (CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size {
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize labelsize = [self boundingRectWithSize:size
                                          options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return labelsize;
}
@end
