//
//  JJBaseTextField.m
//  JinJiangDuCheng
//
//  Created by Perry on 15/4/8.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "MBTextFieldWithFontAdapter.h"

@implementation MBTextFieldWithFontAdapter
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self status];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [super setFont:[MBFontAdapter adjustFont:self.font]];
}

-(void)setFont:(UIFont *)font{
    [super setFont:[MBFontAdapter adjustFont:font]];
}


//
- (void)status {
    //  Registering for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    //  Getting object
//    UITextField       *_textFieldView = aNotification.object;
//    UIViewController  *vc             = (UIViewController *)[aNotification.object viewController];
//    UIWindow          *keyWindow      = [self keyWindow:_textFieldView];
    
}

/*  UIKeyboardWillHideNotification. So setting rootViewController to it's default frame. */
- (void)keyboardWillHide:(NSNotification*)aNotification {
    
}
/** Getting keyWindow. */
-(UIWindow *)keyWindow:(UITextField *)textfield
{
    if (textfield.window)
    {
        return textfield.window;
    }
    else
    {
        static UIWindow *_keyWindow = nil;
        
        /*  (Bug ID: #23, #25, #73)   */
        UIWindow *originalKeyWindow = [[UIApplication sharedApplication] keyWindow];
        
        //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
        if (originalKeyWindow != nil && _keyWindow != originalKeyWindow)  _keyWindow = originalKeyWindow;
        
        //Return KeyWindow
        return _keyWindow;
    }
}
-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}
@end
