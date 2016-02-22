//
//  SongView.h
//  Sahara
//
//  Created by huangcan on 15/12/11.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "Track+Provider.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"


#import "NSDate+FSExtension.h"
#import "NSString+FSExtension.h"
#import "UIView+Extension.h"
#import <UAProgressView/UAProgressView.h>

//定义枚举类型
typedef enum {
    ENUM_ActionTypePlay,//开始
    ENUM_ActionTypeStop,//停止
    ENUM_ActionTypePause,//暂停
    ENUM_ActionTypeNext,//下一曲
} ENUM_ActionType;

//协议定义
@protocol SongViewDelegate <NSObject>

- (void)showMapView;

- (void)tapUpBtnActionDelegate:(Track *)track type:(ENUM_ActionType)enumType ;

- (void)songPlayAudioStreamer:(DOUAudioStreamer *)streamer;

- (void)collectionSong:(UIButton *)sender songData:(Track *)track;
@end

@interface SongView : UIView {
    
    IBOutlet UAProgressView * _progressView;
    IBOutlet UILabel *_titleLabel;
    IBOutlet UIButton *_buttonPlayPause;
    IBOutlet UIButton *_buttonNext;
    
    IBOutlet UIImageView *_progressImg;
    IBOutlet UIView *_progressBackView;
    
    UILabel *_statusLabel;//留着以后估计会用
    
    
    NSUInteger _currentTrackIndex;
    //音乐播放时间
    NSTimer *_timer;
    
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
    Track *_track;
}
@property (nonatomic,weak) id<SongViewDelegate> delegate;

@property (nonatomic,strong) NSArray * tracks;
/**
 *  @brief 距离
 */
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
/**
 *  @brief 配速
 */
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
/**
 *  @brief 卡路里
 */
@property (strong, nonatomic) IBOutlet UILabel *calorieLabel;
/**
 *  @brief GPS
 */
@property (weak, nonatomic) IBOutlet UILabel *GPSLabel;

/**
 *  @brief 跑步时间
 */
@property (strong, nonatomic) IBOutlet UILabel *labelRunTimer;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;

- (instancetype)initWithSongData:(NSArray *)arr;

@end
