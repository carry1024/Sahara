//
//  ChangeName.m
//  Sahara
//
//  Created by heng on 15/12/28.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ChangeName.h"
#import "personalDataViewController.h"


@implementation ChangeName
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:_view];
    self.name.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_name];
}
- (IBAction)sureAction:(UIButton *)sender {
    if (_name.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能位空"];
        return;
    }
    //网络请求
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"cancleChangeName" object:nil userInfo:@{@"name": _name.text}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
- (IBAction)cancleAction:(UIButton *)sender {
    ////创建通知取消弹框
    NSNotification * notice = [NSNotification notificationWithName:@"cancleChangeNameCancle" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}



#pragma mark -- UITextfielfDelegate imp
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (_name.text.length > 12) {
                textField.text = [toBeString substringToIndex:12];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (_name.text.length > 12) {
            textField.text = [toBeString substringToIndex:12];
        }
    }
}
@end
