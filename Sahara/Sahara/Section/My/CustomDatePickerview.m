//
//  CustomPickerview.m
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/8.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "CustomDatePickerview.h"

@implementation CustomDatePickerview

-(void)awakeFromNib
{
    [super awakeFromNib];
    backview    = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backview.backgroundColor    = [UIColor blackColor];
    backview.alpha              = .4;
    UITapGestureRecognizer  *gesture    = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelEvent:)];
    [backview addGestureRecognizer:gesture];
    [self addSubview:backview];
    
    _datePicker.backgroundColor  = [UIColor whiteColor];
    _datePicker.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    //    _datePicker.maximumDate      = [NSDate date];
    [self addSubview:_datePicker];
    [self addSubview:handleView];
}

- (IBAction)doneEvent:(id)sender
{
    if (_RequestFinishBlock)
    {
        NSDateFormatter *formatter  = [[NSDateFormatter alloc]init];
        _isShowDateAndTime ? [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] : [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *time              = [formatter stringFromDate:_datePicker.date];
        _RequestFinishBlock(time);
    }
    [backview removeFromSuperview];
    [self removeFromSuperview];
}
- (IBAction)cancelEvent:(id)sender
{
    [backview removeFromSuperview];
    [self removeFromSuperview];
}


@end
