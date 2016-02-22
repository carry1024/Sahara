//
//  MyViewController.h
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface MyViewController : FatherViewController
@property (weak, nonatomic) IBOutlet UIImageView *headImage; //头像图片
@property (weak, nonatomic) IBOutlet UILabel *name;          //名字
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;  //性别图片
@property (weak, nonatomic) IBOutlet UILabel *sex;           //性别
@property (weak, nonatomic) IBOutlet UILabel *level;         //等级
@property (weak, nonatomic) IBOutlet UILabel *cumulative;    //累计公里
@property (weak, nonatomic) IBOutlet UILabel *longTime;      //最长时间
@property (weak, nonatomic) IBOutlet UILabel *longDistance;  //最长距离
@property (weak, nonatomic) IBOutlet UILabel *speed;         //最快配速
- (void)getData;
@end
