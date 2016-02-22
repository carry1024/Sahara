//
//  RuningViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/10.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RuningViewController.h"
#import "RunSaveController.h"

#import "SongView.h"
#import "MapView.h"
#import "Track+Provider.h"
#import "Track.h"

#import "FMDB_Help.h"


static void *SingleTimeKVOKey = &SingleTimeKVOKey;

@interface RuningViewController ()<SongViewDelegate,MapViewDelegate>
{
    //跑步时间
    NSTimer * _runTimer;
    NSString * _runDateStr;
    //单曲所用时间
    NSTimeInterval _singleDateStr;
    //开始距离
    NSString * _startMapDistance;
    //结束距离
    NSString * _endMapDistance;
    RunSaveController * _runSave;
    
    //体重
    NSString *weight;
}

@property (nonatomic, strong)SongView * songView;
@property (nonatomic, strong)MapView * mapView;

//跑步数据
@property (nonatomic, strong) NSMutableDictionary *runDataDic;
//跑步段数数据
@property (nonatomic, strong) NSMutableArray *runNumDataArray;
//歌曲数据
@property (nonatomic, strong) NSMutableArray *musicDataArray;
//GPS数据
@property (nonatomic, strong) NSMutableArray *GPSDataArray;

@end

@implementation RuningViewController

#pragma mark -- 系统方法


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_runTimer invalidate];
    _runTimer = nil;
    [_mapView.locationTimer invalidate];
    _mapView.locationTimer = nil;
    _mapView.mapView.showsUserLocation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weight = [UserData UserDefaults:@"Weight"];
    
    _mapView = [[MapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    _mapView.hidden = YES;
    
    //观察跑步距离变化
    [_mapView addObserver:self forKeyPath:@"distance" options:NSKeyValueObservingOptionNew context:nil];
    //观察GPS信号强弱
    [_mapView addObserver:self forKeyPath:@"GPSDifference" options:NSKeyValueObservingOptionNew context:nil];
    //观察seep速度变化
    [_mapView addObserver:self forKeyPath:@"locationSpeed" options:NSKeyValueObservingOptionNew context:nil];
    /**
     初始化歌曲界面
     */
    _songView = [[SongView alloc]initWithSongData:_songArr];
    _songView.delegate = self;
    
    [self.view addSubview:_songView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _runTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runtimerAction:) userInfo:    nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_runTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    //开始跑步时间
    _runDateStr = @"00 : 00 : 00";
    //开始跑步距离
    _startMapDistance = @"0";
}

#pragma mark - SongViewDelegate,MapViewDelegate

- (void)showMapView {
    
    _songView.hidden = YES;
    _mapView.hidden  = NO;
    
}

- (void)showSongView
{
    _songView.hidden = NO;
    _mapView.hidden = YES;
}

- (void)tapUpBtnActionDelegate:(Track *)track type:(ENUM_ActionType)enumType{
    switch (enumType) {
            //播放
        case ENUM_ActionTypePlay:
            if (_mapView.mapView.showsUserLocation == NO) {
                _mapView.mapView.showsUserLocation = YES;
                //移除终点标注
//                [_mapView removePointAnnotation];
            }
            
            [_runTimer setFireDate:[NSDate distantPast]];
            [_mapView.locationTimer setFireDate:[NSDate distantPast]];
            //开始跑步距离
            _startMapDistance = [_mapView.showDistance.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
            //歌曲内容
            _mapView.track = track;
            
            break;
            //暂停
        case ENUM_ActionTypePause:
            
            [_runTimer setFireDate:[NSDate distantFuture]];
//            _mapView.isStopRunning = YES;
            [_mapView.locationTimer setFireDate:[NSDate distantFuture]];
            _mapView.mapView.showsUserLocation = NO;
            
            break;
            //下一曲
        case ENUM_ActionTypeNext:
            
            //结束跑步距离  
            _endMapDistance = [_mapView.showDistance.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
            
            //保存数据
            [self saveMusicDataSingleSongInfo:track];
            break;
            //结束
        case ENUM_ActionTypeStop:
            
            //结束跑步距离
            _endMapDistance = [_mapView.showDistance.text stringByReplacingOccurrencesOfString:@"公里" withString:@""];
            //保存数据
            [self saveMusicDataSingleSongInfo:track];
            
            [self saveRunData];
            
            [_runTimer invalidate];
            
            break;
        default:
            break;
    }
}

/**
 *  @brief 观察播放歌曲对象
 *
 */
- (void)songPlayAudioStreamer:(DOUAudioStreamer *)streamer {
    
    _singleDateStr = [streamer currentTime];
    [_mapView.progressView setProgress:[streamer currentTime] / [streamer duration]];
}
//保存歌曲数据
- (void)saveMusicDataSingleSongInfo:(Track *)track {
    //单曲播放时间
    NSString * singleTime =  [NSString stringWithFormat:@"%.0f",_singleDateStr * 1000];
    NSString * like = [NSString stringWithFormat:@"%hhd",(char)track.like];
    [[FMDB_Help sharedInstance]inDatabase:^(FMDatabase *db1) {
        //添加新消息数据
        [db1 executeUpdate:@"INSERT INTO Music ('time','start','end','musicId','musicImg','musicName','musicSinger','like') VALUES (?,?,?,?,?,?,?,?)",singleTime,_startMapDistance,_endMapDistance,track.songId,track.picture,track.title,track.artist,like];
    }];
}

//收藏歌曲//SongView
- (void)collectionSong:(UIButton *)sender songData:(Track *)track{
    
    NSString * url = nil;
    NSString * loding = nil;
    if (sender.selected == YES) {
        url = URI_RUN_SONGDELSONGLIKE;
        loding = @"取消收藏...";
    } else {
        url = URI_RUN_ADDSONGLIKE;
        loding = @"添加收藏...";
    }
    [RequestManager PostUrl:url loding:loding dic:@{@"contentId":track.songId} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            sender.selected = !sender.selected;
            track.like = sender.selected;
            _mapView.collection.selected = sender.selected;
            _songView.collectBtn.selected = sender.selected;
            [SVProgressHUD showSuccessWithStatus:@"成功"];
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
    
}

//收藏歌曲//MapView
- (void)collectionSong:(UIButton *)sender {
    
    [self collectionSong:sender songData:_mapView.track];
}
#pragma mark - 其他
//跑步时间
- (void)runtimerAction:(NSTimer *)timer
{
    DLog(@"%@",timer);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate * date = [_runDateStr fs_dateWithFormat:@"HH : mm : ss"];
        date = [date dateByAddingTimeInterval:1];
        _runDateStr = [date fs_stringWithFormat:@"HH : mm : ss"];
        _songView.labelRunTimer.text = _runDateStr;
        _mapView.totalTime.text = _runDateStr;
    });
    
    
    
    
}

//跑步数据
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //总距离
    if ([keyPath isEqualToString:@"distance"]) {
        
        _mapView.showDistance.text = [NSString stringWithFormat:@"%.2f公里",[[_mapView valueForKey:@"distance"] floatValue]];
        _songView.distanceLabel.text = _mapView.showDistance.text;
        //卡路里
        _mapView.calories.text = [self returnsTheCalories:_mapView.showDistance.text];
        _songView.calorieLabel.text = _mapView.calories.text;
        
    }
    
    //GPS
    if ([keyPath isEqualToString:@"GPSDifference"]) {
        
        _mapView.GPS.text = [_mapView valueForKey:@"GPSDifference"];
        _songView.GPSLabel.text = _mapView.GPS.text;
    }
    
    //实时配速
    if ([keyPath isEqualToString:@"locationSpeed"]) {
        if ([[_mapView valueForKey:@"locationSpeed"] floatValue] <= 0) {
            _mapView.speed.text = @"0'00''";
            _songView.speedLabel.text = _mapView.speed.text;
            
        }else{
            
            CGFloat locationSpeed = [[_mapView valueForKey:@"locationSpeed"] floatValue];
            NSInteger minute = (NSInteger)(1000 /(locationSpeed * 60));
            NSInteger minuteInt = (NSInteger)(1000 /(locationSpeed * 60) * 100);
            NSInteger decimal = 0;
            if (minute != 0) {
                decimal = (NSInteger)minuteInt % (minute * 100);
            } else {
                decimal = minuteInt;
            }
            if (decimal == 0) {
                _mapView.speed.text = [NSString stringWithFormat:@"%ld'00''",minute];
                _songView.speedLabel.text       = _mapView.speed.text;
            }else{
                
                int times = (int)floor(decimal * 0.6);
                if (times < 10) {
                    _mapView.speed.text = [NSString stringWithFormat:@"%ld'0%d''",minute,times];
                    _songView.speedLabel.text       = _mapView.speed.text;
                }else{
                    _mapView.speed.text = [NSString stringWithFormat:@"%ld'%d''",minute,times];
                    _songView.speedLabel.text       = _mapView.speed.text;
                }
                
            }
            
        }
    }
}
/**
 * 卡路里计算
 *
 * @param weight   体重
 * @param distance 距离
 *
 * @return 卡路里
 */
- (NSString *)returnsTheCalories:(NSString *)distance
{
    
    return [NSString stringWithFormat:@"%.1f",[distance floatValue]* [weight floatValue] * 1.036f];
}



#pragma mark --保存数据

- (void)saveRunData {
    
    [self takeMusicData];
    [self takeMapGPSData];
    [self takeMapRunData];
    [self takeMapRunNumData];
    
    NSDictionary *dic = @{@"run":_runDataDic,@"runNum":_runNumDataArray,@"music":_musicDataArray,@"gps":_GPSDataArray};
    NSString * data = [RequestManager JsonStr:dic];
    
    [RequestManager PostUrl:URI_RUN_MOVEMENTPUSHRUNDATA loding:@"保存中..." dic:@{@"data":data} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            
            //更新跑步数据
            NSNotification * notice = [NSNotification notificationWithName:KNOTIFICATION_RUNRELOADDATA object:nil userInfo:nil];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
            //在本地数据库中删除本次跑步数据
            [self clearAllRunData];
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _runSave = [[RunSaveController alloc]initWithNibName:@"RunSaveController" bundle:[NSBundle mainBundle]];
                _runSave.runId = response[@"ReturnData"];
                
                [self.navigationController pushViewController:_runSave animated:YES];
            });
        }else {
            
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
    
}

#pragma mark - 取数据
//取出跑步数据：时间，距离
- (void)takeMapRunData
{
    _runDataDic = [NSMutableDictionary dictionary];
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *run = [db executeQuery:@"SELECT * FROM Run"];
        
        while ([run next]) {
            NSString *time = [run stringForColumn:@"time"];
            NSString *distances = [run stringForColumn:@"distance"];
            [_runDataDic setObject:time forKey:@"time"];
            [_runDataDic setObject:distances forKey:@"distance"];
            
        }
    }];
}


//取出跑步分段数据：段数，时间
- (void)takeMapRunNumData
{
    _runNumDataArray = [NSMutableArray array];
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *runNum = [db executeQuery:@"SELECT * FROM RunNum"];
        
        while ([runNum next]) {
            NSString *number = [runNum stringForColumn:@"number"];
            NSString *time = [runNum stringForColumn:@"time"];
            NSDictionary *dic = @{@"number":number,@"time":time};
            [_runNumDataArray addObject:dic];
        }
    }];
}

//取出歌曲数据：时间，开始距离，结束距离，歌曲id
- (void)takeMusicData
{
    _musicDataArray = [NSMutableArray array];
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *music = [db executeQuery:@"SELECT * FROM Music"];
        
        while ([music next]) {
            NSString *time        = [music stringForColumn:@"time"];
            NSString *start       = [music stringForColumn:@"start"];
            NSString *end         = [music stringForColumn:@"end"];
            NSString *musicId     = [music stringForColumn:@"musicId"];
            NSString *musicImg    = [music stringForColumn:@"musicImg"];
            NSString *musicName   = [music stringForColumn:@"musicName"];
            NSString *musicSinger = [music stringForColumn:@"musicSinger"];
            NSString *like        = [music stringForColumn:@"like"];
            NSDictionary *dic     = @{@"time":time,@"start":start,@"end":end,@"musicId":musicId,@"musicImg":musicImg,@"musicName":musicName,@"musicSinger":musicSinger,@"like":like};
            [_musicDataArray addObject:dic];
        }
        
    }];
}


//取出GPS坐标数据：经纬度
- (void)takeMapGPSData
{
    _GPSDataArray = [NSMutableArray array];
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        FMResultSet *GPS = [db executeQuery:@"SELECT * FROM GPS"];
        
        while ([GPS next]) {
            NSString *latitude  = [GPS stringForColumn:@"latitude"];
            NSString *longitude = [GPS stringForColumn:@"longitude"];
            NSDictionary *dic   = @{@"latitude":latitude,@"longitude":longitude};
            [_GPSDataArray addObject:dic];
        }
    }];
    
}

#pragma mark - 删除数据
- (void)clearAllRunData
{
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        BOOL run    = [db executeUpdate:@"DELETE FROM Run"];
        BOOL runNum = [db executeUpdate:@"DELETE FROM RunNum"];
        BOOL music  = [db executeUpdate:@"DELETE FROM Music"];
        BOOL gps    = [db executeUpdate:@"DELETE FROM GPS"];
        
        if (run && runNum && music && gps) {
            NSLog(@"数据库数据删除成功");
        }else{
            NSLog(@"数据库数据删除失败");
        }
    }];
}



- (void)dealloc
{
    [_mapView removeObserver:self forKeyPath:@"distance"];
    [_mapView removeObserver:self forKeyPath:@"GPSDifference"];
    [_mapView removeObserver:self forKeyPath:@"locationSpeed"];
    
}

@end
