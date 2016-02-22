//
//  FatherViewController.h
//  Sahara
//
//  Created by huangcan on 15/5/20.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FatherViewController : UIViewController

- (void)addCustomNavBarTitle:(NSString *)title
                    leftBar:(UIButton *)leftButton
                   rigthBar:(UIButton *)rigthButton whetherAddBackBar:(BOOL)backBar;

- (void)showAlertWithTitle:(NSString *)title;
/**
 *保存用户信息到本地
 */
- (void)saveUserInformation:(NSDictionary *)dic;
/**
 *  左Button返回按钮
 */
- (void)popViewConDelay;


@end
