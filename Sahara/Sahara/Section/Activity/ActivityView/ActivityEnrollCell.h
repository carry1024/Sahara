//
//  ActivityEnrollCell.h
//  Sahara
//
//  Created by huangcan on 16/1/13.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enroll.h"
//协议定义
@protocol ActivityEnrollCellDelegate <NSObject>

- (void)reloadEnrollData:(Enroll *)enroll;

@end

@interface ActivityEnrollCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource> {
    UIPickerView * _picker;
}
@property (strong, nonatomic) IBOutlet UILabel *accordNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *activityTextField;
@property (strong, nonatomic) Enroll * enroll;
@property (strong, nonatomic) id<ActivityEnrollCellDelegate>delegate;

- (void)loadCellData;


@end
