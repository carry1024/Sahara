//
//  MapSaveView.h
//  Sahara
//
//  Created by junzong on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface MapSaveView : UIView



@property (weak, nonatomic) IBOutlet MAMapView *mapView;

/**
 *距离
 */
@property (weak, nonatomic) IBOutlet UILabel *saveDistance;
/**
 *时间
 */
@property (weak, nonatomic) IBOutlet UILabel *saveTime;
/**
 *速度
 */
@property (weak, nonatomic) IBOutlet UILabel *saveSpeed;
/**
 *卡路里
 */
@property (weak, nonatomic) IBOutlet UILabel *saveCalories;


/**
 *绘制跑步路线
 */
- (void)addLineGPSArray:(NSMutableArray *)array;



@end
