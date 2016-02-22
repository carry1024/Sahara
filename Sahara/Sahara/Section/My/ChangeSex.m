//
//  ChangeSex.m
//  Sahara
//
//  Created by heng on 15/12/28.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ChangeSex.h"

@implementation ChangeSex
- (void)awakeFromNib{
    //监听性别，已改变按钮高亮初始状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sexButtonGaoliang:) name:@"sexButtonGaoliang" object:nil];
////    _men.selected = YES;
//    _button = _men;
    
}
- (IBAction)men:(UIButton *)sender {
    self.button.selected = NO;
    sender.selected = YES;
    self.button = sender;
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"cancleChangeSexMen" object:nil userInfo:@{@"sex":@"1"}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
- (IBAction)women:(UIButton *)sender {
    self.button.selected = NO;
    sender.selected = YES;
    self.button = sender;
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"cancleChangeSexWomen" object:nil userInfo:@{@"sex":@"2"}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
- (void)sexButtonGaoliang:(NSNotification *)info{
    NSString *sex = info.userInfo[@"sex"];
    if ([sex isEqualToString:@"男"]) {
        _men.selected = YES;
        _button = _men;
    }else {
        _women.selected = YES;
        _button = _women;
    }
}
@end
