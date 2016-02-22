//
//  RootBar.m
//  Sahara
//
//  Created by huangcan on 15/12/16.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RootBar.h"

@implementation RootBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib * nib = [UINib nibWithNibName:@"RootBar" bundle:[NSBundle mainBundle]];
        NSArray * arr = [nib instantiateWithOwner:nil options:nil];
        self = [arr objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (IBAction)tabbarBtnAction:(UIButton *)sender {
    
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    sender.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = sender;
    
    //却换视图控制器的事情,应该交给controller来做
    //最好这样写, 先判断该代理方法是否实现
    if ([self.delegate respondsToSelector:@selector(tabBar:selectedFrom:to:)]) {
        [self.delegate tabBar:self selectedFrom:self.selectedBtn.tag - 1000 to:sender.tag - 1000];
    }
    
}


@end
