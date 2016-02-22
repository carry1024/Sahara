//
//  RootBar.h
//  Sahara
//
//  Created by huangcan on 15/12/16.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootBar;

@protocol RootBarDelegate <NSObject>
/**
 *  工具栏按钮被选中, 记录从哪里跳转到哪里. (方便以后做相应特效)
 */
- (void) tabBar:(RootBar *)tabBar selectedFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface RootBar : UIView
/**
 *  设置之前选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;

@property(nonatomic,weak) id<RootBarDelegate> delegate;

@end
