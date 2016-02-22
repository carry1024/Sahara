//
//  SongingController.m
//  Sahara
//
//  Created by huangcan on 16/1/15.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "SongingController.h"

#import "Track.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioVisualizer.h"

#import "UAProgressView.h"
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface SongingController ()
{
    UILabel *_statusLabel;
    UISlider *_progressSlider;
    
    
    NSTimer *_timer;
    
    DOUAudioStreamer *_streamer;
    DOUAudioVisualizer *_audioVisualizer;
}

@property (strong, nonatomic) IBOutlet UILabel *miscLabel;
@property (strong, nonatomic) IBOutlet UAProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *pauseBtn;

@end

@implementation SongingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    /**
     *  @brief 进度条
     */
    _progressView.borderWidth = 0.0;
    _progressView.lineWidth = 14.0;
    _progressView.tintColor = RGBA(255, 127, 0, 1);
    _progressView.fillOnTouch = NO;
    _progressView.centralView = _songImage;
    
    //按钮
    [_playBtn addTarget:self action:@selector(actionPlayPause:) forControlEvents:UIControlEventTouchDown];
    [_pauseBtn addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)viewDidLayoutSubviews {
    
    //音乐进度背景
    _progressView.layer.masksToBounds =YES;
    _progressView.layer.cornerRadius = _progressView.bounds.size.width/2;
    
    _songImage.layer.masksToBounds =YES;
    _songImage.layer.cornerRadius = _songImage.bounds.size.width/2;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _resetStreamer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
    [_streamer stop];
    [self _cancelStreamer];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [_miscLabel setText:@"(No tracks available)"];
        
        [_songImage setImage:[UIImage imageNamed:@"song_logo"]];
    }
    else
    {
        Track * track = [_tracks objectAtIndex:_currentTrackIndex];
        NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
        [_miscLabel setText:title];
        /**
         *  @brief 歌曲头像
         */
        NSString * picture = [NSString stringWithFormat:@"%@",track.picture];
        [_songImage sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"song_logo"]];
        
        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
        
        //播放
        [_streamer play];
        
        [self setupHintForStreamer];
        
    }
}

- (void)_updateBufferingStatus
{
//    [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
    
    if ([_streamer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [_streamer sha256]);
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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
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
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
}

- (void)_actionNext:(id)sender
{
    if (++_currentTrackIndex >= [_tracks count]) {
        _currentTrackIndex = 0;
    }
    
    [self _resetStreamer];
}

- (void)_actionStop:(id)sender
{
    [_streamer stop];
}

- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            [_statusLabel setText:@"playing"];
//            [_buttonPlayPause setTitle:@"Pause" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
            [_statusLabel setText:@"paused"];
//            [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerIdle:
            [_statusLabel setText:@"idle"];
//            [_buttonPlayPause setTitle:@"Play" forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerFinished:
            [_statusLabel setText:@"finished"];
            [self _actionNext:nil];
            break;
            
        case DOUAudioStreamerBuffering:
            [_statusLabel setText:@"buffering"];
            break;
            
        case DOUAudioStreamerError:
            [_statusLabel setText:@"error"];
            break;
    }
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

        //播放
        [_streamer play];
        _playBtn.selected = NO;
        _pauseBtn.selected = NO;
        
    }
    else {
        
        //暂停
        [_streamer pause];
        _playBtn.selected = YES;
        _pauseBtn.selected = YES;
        
    }
}
/**
 *  @brief 下一曲结束
 *
 *  @param sender _buttonNext
 */
- (void)actionNext:(UIButton *)sender
{
    if (sender.selected == NO) {
        if (++_currentTrackIndex >= [_tracks count]) {
            _currentTrackIndex = 0;
        }
        
        [self _resetStreamer];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)popBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 时间方法
- (void)timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [_progressView setProgress:0.0f];
    } else {
        [_progressView setProgress:[_streamer currentTime] / [_streamer duration]];
    }
}

@end
