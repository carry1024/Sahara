//
//  RunSaveController.h
//  Sahara
//
//  Created by huangcan on 15/12/16.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface RunSaveController : FatherViewController

/**
 *分享按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

/**
 *距离
 */
@property (weak, nonatomic) IBOutlet UILabel *runNumDistance;
/**
 *时间
 */
@property (weak, nonatomic) IBOutlet UILabel *runNumTime;
/**
 *速度
 */
@property (weak, nonatomic) IBOutlet UILabel *runNumSpeed;
/**
 *卡路里
 */
@property (weak, nonatomic) IBOutlet UILabel *runNumCalories;

//跑步详情
@property (nonatomic, strong) NSString *runId;
//是否是跑步详情
@property (nonatomic) BOOL isRunDetails;


@end
