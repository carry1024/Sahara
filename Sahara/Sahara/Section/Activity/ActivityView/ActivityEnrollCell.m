//
//  ActivityEnrollCell.m
//  Sahara
//
//  Created by huangcan on 16/1/13.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "ActivityEnrollCell.h"


@implementation ActivityEnrollCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)loadCellData {
    _picker = [[UIPickerView alloc]init];
    _picker.delegate = self;
    _picker.dataSource = self;
    
    _activityTextField.inputView = _picker;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_enroll.enrollArr count];
}
- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_enroll.enrollArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
//    [self.delegate reloadEnrollData:_enroll];
    
    _activityTextField.text = [_enroll.enrollArr objectAtIndex:row];
}

@end
