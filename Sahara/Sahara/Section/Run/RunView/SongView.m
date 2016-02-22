//
//  SongView.m
//  Sahara
//
//  Created by huangcan on 15/12/11.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DOUAudioEventLoop.h"

#import "SongView.h"
//#import "HSDownloadManager.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

static BOOL isnextBtn;
@implementation SongView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    _progressImg.layer.masksToBounds =YES;
    _progressImg.layer.cornerRadius = _progressImg.bounds.size.width/2;
    
    //音乐进度背景
    _progressBackView.layer.masksToBounds =YES;
    _progressBackView.layer.cornerRadius = _progressBackView.bounds.size.width/2;
    
    //播放
    [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePlay];
}

- (instancetype)initWithSongData:(NSArray *)arr {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SongView" owner:self options:nil];
    self = [nibView objectAtIndex:0];
    //数据
    [self setTracks:[Track remoteTracks:arr]];
    //界面
    [self loadMyView];
    

    return self;
}

- (void)onAudioSessionEvent:(NSNotification *)notification {
    
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        //跑步暂停
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePause];
        //暂停
        [_streamer pause];
        _buttonPlayPause.selected = YES;
        _buttonNext.selected = YES;
    });
}

- (void)endAudioSessionEvent:(NSNotification *)notification {
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        //跑步继续
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePlay];
        //播放
        [_streamer play];
        _buttonPlayPause.selected = NO;
        _buttonNext.selected = NO;
    });
    
    
}

- (void)loadMyView
{
    
    
    [self _resetStreamer];
    /**
     *  @brief 进度条
     */
    _progressView.borderWidth = 0.0;
    _progressView.lineWidth = 14.0;
    _progressView.tintColor = RGBA(255, 127, 0, 1);
    _progressView.fillOnTouch = NO;
    _progressView.centralView = _progressImg;
    
    //按钮
    [_buttonPlayPause addTarget:self action:@selector(actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [_buttonNext addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchDown];
    
    //时间
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notficationNextSong:) name:@"nextSong" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:KNOTIFICATION_SONGRESTART object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endAudioSessionEvent:) name:KNOTIFICATION_SONGEND object:nil];
}

- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
    if (0 == [_tracks count])
    {
        [_titleLabel setText:@"(No tracks available)"];
        
        [_progressImg setImage:[UIImage imageNamed:@"song_logo"]];
    }
    else
    {
        _track = [_tracks objectAtIndex:_currentTrackIndex];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", _track.artist, _track.title];
        [_titleLabel setText:title];
        /**
         *  @brief 歌曲头像
         */
        NSString * picture = [NSString stringWithFormat:@"%@",_track.picture];
        [_progressImg sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"song_logo"]];
        //是否收藏
        _collectBtn.selected = _track.like;
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:_track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        //播放
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePlay];
        [_streamer play];
        
//        [self updateBufferingStatus];
        [self setupHintForStreamer];
        
    }
}

- (void)setupHintForStreamer
{
    NSUInteger nextIndex = _currentTrackIndex + 1;
    if (nextIndex >= [_tracks count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

#pragma mark 时间方法
- (void)timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [_progressView setProgress:0.0f];
    } else {
        [_progressView setProgress:[_streamer currentTime] / [_streamer duration]];
        //跑步小界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate songPlayAudioStreamer:_streamer];
        });
    }
}

//- (void)runtimerAction:(NSTimer *)timer
//{   
//    NSDate * date = [_labelRunTimer.text fs_dateWithFormat:@"HH : mm : ss"];
//    date = [date dateByAddingTimeInterval:1];
//    _labelRunTimer.text = [date fs_stringWithFormat:@"HH : mm : ss"];
//}

- (void)updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            [_statusLabel setText:@"playing"];
            break;
            
        case DOUAudioStreamerPaused:
            [_statusLabel setText:@"paused"];
            break;
            
        case DOUAudioStreamerIdle:
            [_statusLabel setText:@"idle"];
            break;
            
        case DOUAudioStreamerFinished:
            [_statusLabel setText:@"finished"];
            [self actionNext:nil];
            break;
            
        case DOUAudioStreamerBuffering:
            [_statusLabel setText:@"buffering"];
            break;
            
        case DOUAudioStreamerError:
            [_statusLabel setText:@"error"];
            break;
    }
}

- (void)updateBufferingStatus
{
    //[_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
    
//    if ([_streamer bufferingRatio] >= 1.0) {
//        DLog(@"sha256: %@", [_streamer sha256]);
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -- 系统方法

- (void)dealloc
{
    [_timer invalidate];
    [_streamer stop];
    [self _cancelStreamer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- 点击事件
/**
 *  @brief 播放暂停
 *
 *  @param sender _buttonPlayPause
 */
- (void)actionPlayPause:(UIButton *)sender
{
    
    
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        //跑步继续
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePlay];
        //播放
        [_streamer play];
        _buttonPlayPause.selected = NO;
        _buttonNext.selected = NO;
        
    }
    else {
        //跑步暂停
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypePause];
        //暂停
        [_streamer pause];
        _buttonPlayPause.selected = YES;
        _buttonNext.selected = YES;
        
    }
   
}

/**
 *  @brief 下一曲结束
 *
 *  @param sender _buttonNext
 */
- (void)actionNext:(UIButton *)sender
{
    
    if (isnextBtn == YES) {
        return;
    }
    
    if (sender.selected == NO) {
        if (++_currentTrackIndex >= [_tracks count]) {
            _currentTrackIndex = 0;
        }
        isnextBtn = YES;
        //跑步歌曲下一曲
        [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypeNext];
        
        [self _resetStreamer];

    } else {
        
        NSString * dis = [_distanceLabel.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
        if ([dis floatValue] <= 0.2) {
            [SVProgressHUD showInfoWithStatus:@"你跑步的距离小于200米,不能保存"];
            return;
        }
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                        message:@"确定结束本次跑步并保存数据吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        alert.tag = 200;
        [alert show];
    }
    
    [self performSelector:@selector(todoSomething) withObject:sender afterDelay:2];
}
- (void)todoSomething {
    
    isnextBtn = NO;
}
/**
 *  @brief 地图通知下一首歌曲
 *
 *  @param sender 通知
 */
- (void) notficationNextSong:(NSNotification *)sender {
    
    if (++_currentTrackIndex >= [_tracks count]) {
        _currentTrackIndex = 0;
    }
    
    //跑步歌曲下一曲
    [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypeNext];
    
    [self _resetStreamer];
}
/**
 *  @brief 退出
 *
 *  @param sender 退出按钮
 */
- (IBAction)popBtnAction:(UIButton *)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                    message:@"退出将取消保存此次跑步记录"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"退出", nil];
    alert.tag = 300;
    [alert show];
}

/**
 *  @brief 显示地图
 *
 *  @param sender GPS按钮
 */
- (IBAction)showMapViewTapGesture:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SongViewDelegate)]) {
        [self.delegate showMapView];
    }

}
/**
 *  @brief 收藏
 *
 *  @param sender 收藏按钮
 */
- (IBAction)collectionBtnAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(SongViewDelegate)]) {
        
        [self.delegate collectionSong:sender songData:_track];
    }
    
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 200) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endRun" object:nil];
            [_streamer stop];
            /**
             *  @brief 关闭播放
             */
            [_timer invalidate];
            [_streamer stop];
            [self _cancelStreamer];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            //跑步结束
            [self.delegate tapUpBtnActionDelegate:_track type:ENUM_ActionTypeStop];
            
        } else {
            
            
        }
    }
    if (alertView.tag == 300) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //修复BUG，不走dealloc，保守方法
                [_timer invalidate];
                [_streamer stop];
                [self _cancelStreamer];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                
                [self.myViewController.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }
    
}

@end
