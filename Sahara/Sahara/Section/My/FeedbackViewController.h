//
//  FeedbackViewController.h
//  Sahara
//
//  Created by zhaoxiaoling on 15/6/26.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//  意见反馈

#import "FatherViewController.h"

@interface FeedbackViewController : FatherViewController<UITextViewDelegate>
{
    UILabel         *_placeHolder;
    UITextView      *_textView;
    UIButton        *_commitButton;
}

@end
