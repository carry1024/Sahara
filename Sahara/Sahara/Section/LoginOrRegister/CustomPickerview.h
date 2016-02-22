//
//  CustomPickerview.h
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/9.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    pickerType_weight=1,
    pickerType_height,
    pickerType_score,
    pickerType_date
}pickerType;

@interface CustomPickerview : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView                          *backview;
    __weak IBOutlet UIView          *handleview;
//    __weak IBOutlet UIPickerView    *pickerview;
}

@property (nonatomic,assign)int     pickerType;
@property (nonatomic,strong)void(^RequestFinishBlock)(NSString *str);
@property (weak, nonatomic) IBOutlet UIPickerView *pickerview;

@end
