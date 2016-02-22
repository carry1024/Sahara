//
//  FeedbackViewController.m
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/26.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "FeedbackViewController.h"
#define MAX_LIMIT_NUMS     200
@interface FeedbackViewController ()<UITextInput>

@end

@implementation FeedbackViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _placeHolder        = [[UILabel alloc]initWithFrame:CGRectZero];
        _textView           = [[UITextView alloc]initWithFrame:CGRectZero];
        _textView.delegate  = self;
        _commitButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.delegate = self;
    [self addCustomNavBarTitle:@"意见反馈" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    self.view.backgroundColor           = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    _textView.frame                     = CGRectMake(15, 64+10, ScreenWidth-30, ScreenWidth/320.0*200);
    _textView.layer.cornerRadius        = 10;
    _textView.layer.masksToBounds       = YES;
    _textView.layer.borderColor         = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1].CGColor;
    _textView.layer.borderWidth         = .5;
    _commitButton.frame     = CGRectMake(15, _textView.frame.origin.y+_textView.frame.size.height+20, _textView.frame.size.width, 40);
    [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitButton setBackgroundColor:MAINCOLOR];
    [_commitButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    _commitButton.layer.cornerRadius    = 10;
    _commitButton.layer.masksToBounds   = YES;
    _placeHolder.frame      = CGRectMake(_textView.frame.origin.x+5, _textView.frame.origin.y+5, _textView.frame.size.width-10, 20);
    _placeHolder.text       = @"请输入您的意见或建议...(少于200字)";
    _placeHolder.font       = [UIFont systemFontOfSize:12.0f];
//    _placeHolder.textColor  = RGBA(242,242,242,1);
    [self.view addSubview:_textView];
    [self.view addSubview:_commitButton];
    [self.view addSubview:_placeHolder];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets   = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        _placeHolder.hidden = NO;
    }
    else
    {
        _placeHolder.hidden = YES;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
        //不让显示负数
//        self.lbNums.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}
//代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (range.location >= 200 && _textView == textView) {
//        return NO;
//    }
//    return YES;
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}

-(void)commitEvent:(UIButton*)button
{
    if (_textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"反馈内容不能为空"];
        return;
    }
    [RequestManager PostUrl:URI_My_AddFeedBack loding:nil dic:@{@"content":_textView.text} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            [SVProgressHUD showSuccessWithStatus:response[@"ReturnMsg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
