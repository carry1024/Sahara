//
//  CustomPickerview.m
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/9.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "CustomPickerview.h"

@implementation CustomPickerview

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    backview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backview.backgroundColor    = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    [self addSubview:backview];
    
    _pickerview.backgroundColor  = [UIColor whiteColor];
    _pickerview.delegate         = self;
    _pickerview.dataSource       = self;
    
    [self addSubview:handleview];
    [self addSubview:_pickerview];
    
}
- (void)setPickerType:(int)pickerType{
    _pickerType = pickerType;
    if (_pickerview && _pickerType == pickerType_weight) {
        [_pickerview selectRow:30 inComponent:0 animated:NO];
    }
    if (_pickerview && _pickerType == pickerType_height) {
        [_pickerview selectRow:110 inComponent:0 animated:NO];
    }
}

- (IBAction)cancelEvent:(id)sender
{
    [backview removeFromSuperview];
    [self removeFromSuperview];
}
- (IBAction)sureEvent:(id)sender
{
    if (_RequestFinishBlock)
    {
        _RequestFinishBlock([self valueForPicker]);
    }
    [backview removeFromSuperview];
    [self removeFromSuperview];
}


-(NSString *)valueForPicker
{
    if (_pickerType == pickerType_weight)
    {
        NSInteger row1 = [_pickerview selectedRowInComponent:0];
//        NSInteger row2 = [_pickerview selectedRowInComponent:1];
        return [NSString stringWithFormat:@"%ld",row1+20];
    }
    else if (_pickerType == pickerType_height)
    {
        return [NSString stringWithFormat:@"%ld",[_pickerview selectedRowInComponent:0]+50];
    }
    else if (_pickerType == pickerType_score)
    {
        NSString *row1 = [_pickerview selectedRowInComponent:0]<10?[@"0"stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:0]]]:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:0]];
        NSString *row2 = [_pickerview selectedRowInComponent:1]<10?[@"0"stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:1]]]:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:1]];
        NSString *row3 = [_pickerview selectedRowInComponent:2]<10?[@"0"stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:2]]]:[NSString stringWithFormat:@"%ld",(long)[_pickerview selectedRowInComponent:2]];
        return [NSString stringWithFormat:@"%@:%@:%@",row1,row2,row3];
    }
    return nil;
}

#pragma mark - pickerview delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_pickerType==pickerType_weight)
    {
        return 1;
    }
    else if (_pickerType == pickerType_height)
    {
        return 1;
    }
    else if (_pickerType == pickerType_score)
    {
        return 3;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickerType==pickerType_weight)
    {
//        if (component ==0)
//        {
//            return 220-20+1;
//        }
        return 220-20+1;
    }
    else if (_pickerType == pickerType_height)
    {
        return 220-50+1;
    }
    else if (_pickerType == pickerType_score)
    {
        return 60;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickerType == pickerType_weight)
    {
        if (component==0)
        {
            return [NSString stringWithFormat:@"%ld",20+row];
        }
//        else
//        {
//            return [NSString stringWithFormat:@"%ld",(long)row];
//        }
    }
    else if (_pickerType == pickerType_height)
    {
        return [NSString stringWithFormat:@"%ld",50+row];
    }
    else if (_pickerType == pickerType_score)
    {
        if (row<10)
        {
            return [@"0"stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)row]];
        }
        return [NSString stringWithFormat:@"%ld",(long)row];
    }
    return nil;
}



@end
