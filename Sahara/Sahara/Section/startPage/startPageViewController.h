//
//  startPageViewController.h
//  Sahara
//
//  Created by junzong on 16/1/25.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)

@interface startPageViewController : UIViewController

+ (CGRect)buttonRect;

@end
