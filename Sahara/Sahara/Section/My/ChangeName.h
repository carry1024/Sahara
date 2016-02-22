//
//  ChangeName.h
//  Sahara
//
//  Created by heng on 15/12/28.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeName : UIView <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIView *view;
@property(nonatomic, assign)NSInteger maxWords;

@end
