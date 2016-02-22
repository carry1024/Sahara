//
//  MapView.h
//  Sahara
//
//  Created by junzong on 15/12/14.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <UAProgressView.h>

#import "Track.h"

@protocol MapViewDelegate <NSObject>

/**
 *显示歌曲界面
 */
- (void)showSongView;

//收藏歌曲
- (void)collectionSong:(UIButton *)sender;

@end


@interface MapView : UIView

@property (nonatomic, assign) id<MapViewDelegate> delegate;

//每过n秒获取一次位置来判断当前是否在运动
@property (nonatomic, strong) NSTimer        *locationTimer;

//地图View
@property (weak, nonatomic  ) IBOutlet       MAMapView      *mapView;

@property (strong, nonatomic) Track          * track;
/**
 *头像
 */
@property (strong, nonatomic) IBOutlet       UAProgressView *progressView;
@property (strong, nonatomic) IBOutlet       UIView         *progressBackView;

@property (strong, nonatomic) IBOutlet       UIImageView    *progressImg;

/**
 *歌曲
 */
@property (weak, nonatomic  ) IBOutlet       UILabel         *song;
/**
 *歌手
 */
@property (weak, nonatomic  ) IBOutlet       UILabel         *songName;
/**
 *收藏
 */
@property (weak, nonatomic  ) IBOutlet       UIButton        *collection;
/**
 *下一曲
 */
@property (weak, nonatomic  ) IBOutlet       UIButton        *nextSong;

/**
 *跑步时间
 */
@property (weak, nonatomic  ) IBOutlet       UILabel         *totalTime;
/**
 *GPS
 */
@property (weak, nonatomic  ) IBOutlet       UILabel         *GPS;
/**
 *显示的距离
 */
@property (weak, nonatomic  ) IBOutlet       UILabel   *showDistance;
/**
 *配速
 */
@property (weak, nonatomic  ) IBOutlet       UILabel   *speed;
/**
 *卡路里
 */
@property (weak, nonatomic  ) IBOutlet       UILabel   *calories;
//跑步结束
@property (nonatomic        ) BOOL      isStopRunning;

- (instancetype)initWithFrame:(CGRect)frame;
//移除终点标示
//- (void)removePointAnnotation;
@end
