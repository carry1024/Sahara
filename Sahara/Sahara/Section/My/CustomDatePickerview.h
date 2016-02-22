//
//  CustomPickerview.h
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/8.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePickerview : UIView
{
    UIView                          *backview;
    __weak IBOutlet UIView          *handleView;
}
@property (assign) BOOL isShowDateAndTime;
@property (nonatomic,strong)void(^RequestFinishBlock)(NSString *str);
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
