//
//  MapView.m
//  Sahara
//
//  Created by junzong on 15/12/14.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "MapView.h"
#import "FMDB_Help.h"
#import "NSString+FSExtension.h"


static BOOL isnextButton;

@interface MapView ()<MAMapViewDelegate>
{
    //是否在跑步
    BOOL _isStartRunning;
    
    //画线开始位置经纬度
    CLLocationCoordinate2D startLocation;
    //计算距离开始位置经纬度
    CLLocationCoordinate2D startDistance;
    //跑步总距离
    CLLocationDistance distance;
    //默认公里数：一公里
    NSInteger mileMeter;
    //每过好多米，标记一下坐标用来描线
    float sign;
    //GPS强度
    NSString *GPSDifference;
    //记录每公里的开始时间
    NSString *startTime;
    //speed速度-1
    CGFloat locationSpeed;
    //终点标注
    MAPointAnnotation *endAnnotation;
    
    /**
     *  判断坐标是否一样，一样速度为0，不一样再计算速度
     */
    //前一个坐标经纬度
    CLLocationCoordinate2D onLocation;
    //当前坐标经纬度
    CLLocationCoordinate2D currentLocation;
    /**
     *  配速两次判断为0就把配速置为0
     */
    NSInteger number;
    
    
}

//配速数组-1
@property (nonatomic, strong) NSMutableArray *speedArray;

@end


@implementation MapView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _progressImg.layer.masksToBounds =YES;
    _progressImg.layer.cornerRadius = _progressImg.bounds.size.width/2;
    
    //音乐进度背景
    _progressBackView.layer.masksToBounds =YES;
    _progressBackView.layer.cornerRadius = _progressBackView.bounds.size.width/2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MapView" owner:self options:nil] firstObject];
        self.frame = frame;
        [self loadInterface];
    }
    return self;
}
//数据设置
- (void)setTrack:(Track *)track {
    _track = track;
    
    /**
     *  @brief 歌曲内容
     */
    _song.text = [NSString stringWithFormat:@"%@",track.title];
    _songName.text = [NSString stringWithFormat:@"%@",track.artist];
    /**
     *  @brief 歌曲头像
     */
    [_progressImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",track.picture]] placeholderImage:[UIImage imageNamed:@"song_logo"]];
    //收藏按钮
    _collection.selected = track.like;
}

- (void)loadInterface
{
    //配速数组-2
    _speedArray = [[NSMutableArray alloc] init];
    mileMeter = 1;
    sign = 0.01;
    startTime = @"00:00:00";
    GPSDifference = @"GPS（强）";
    number = 0;
    [self showLocation];

    /**
     *  @brief 进度条
     */
    _progressView.borderWidth = 0.0;
    _progressView.lineWidth = 5.0;
    _progressView.tintColor = RGBA(255, 127, 0, 1);
    _progressView.fillOnTouch = NO;
    _progressView.centralView = _progressImg;
    
    //未满一千米也要保存一条数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRunSaveMapRunNumData) name:@"endRun" object:nil];
    
    //每6秒获取一次位置来判断当前是否在运动
    _locationTimer = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(takeLocation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_locationTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 初始地图
- (void)showLocation
{
    
    //延迟三秒加载代理
    [self performSelector:@selector(loadMapDelegate) withObject:nil afterDelay:3.0f];
    
    //缩放级别
    [_mapView setZoomLevel:16.1 animated:YES];
    //设置允许后台定位参数，保持不会被系统挂起
    _mapView.pausesLocationUpdatesAutomatically = NO;
    //是否允许后台定位。iOS9(含)以上系统需设置
    _mapView.allowsBackgroundLocationUpdates    = YES;
    //设定定位精度。默认为kCLLocationAccuracyBest。
    _mapView.desiredAccuracy                    = kCLLocationAccuracyBest;
    //设定定位的最小更新距离。默认为kCLDistanceFilterNone，会提示任何移动。
    _mapView.distanceFilter                     = kCLDistanceFilterNone;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    //是否显示用户位置
    _mapView.showsUserLocation                  = YES;
    //是否显示罗盘，默认为YES
    _mapView.showsCompass                       = NO;
    //是否显示比例尺，默认为YES
    _mapView.showsScale                         = NO;
}

- (void)loadMapDelegate
{
    _mapView.delegate = self;
    
}

#pragma mark - 起点加载完成改变定位更新距离
- (void)changeLocationUpdate
{
    _mapView.distanceFilter = 10.0f;
    _mapView.headingFilter  = 90;
}

#pragma mark - 抓取坐标判断速度
- (void)takeLocation
{
    
    //speed速度-4
    if (onLocation.latitude == currentLocation.latitude && onLocation.longitude == currentLocation.longitude) {
        
        number += 1;
        if (number == 2) {
            [self setValue:[NSString stringWithFormat:@"0"] forKey:@"locationSpeed"];
            number = 0;
        }
        
        return;
    }
    
    number = 0;
    onLocation = currentLocation;
    
    
    //speed速度-2
    locationSpeed = 0.0;
    
    NSInteger index = 0;
    //配速数组-4
    for (int i = 0; i < _speedArray.count; i++) {
        CLLocation *location = _speedArray[i];
        
        
        if (location.speed > 0) {
            locationSpeed += location.speed;
            index++;
        }
        
    
    }
    if (index != 0) {
        [self setValue:[NSString stringWithFormat:@"%.2f",locationSpeed / index] forKey:@"locationSpeed"];
    }else{
        [self setValue:[NSString stringWithFormat:@"0"] forKey:@"locationSpeed"];
    }
    
    
}

#pragma mark - 定位
//位置或者设备方向更新后调用此接口,定位经纬度
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    //配速数组-3
    if (_speedArray.count == 3) {
        [_speedArray removeObjectAtIndex:0];
    }
    [_speedArray addObject:userLocation.location];
    
    
    CGFloat gps     = userLocation.location.horizontalAccuracy;
//    locationSpeed   = userLocation.location.speed;
    currentLocation = userLocation.location.coordinate;
    if (gps < 0) {
        //极差
    GPSDifference   = @"GPS（极差）";
    }
    if (gps < 20)
    {
        //强
    GPSDifference   = @"GPS（强）";
    }
    else if (gps < 70)
    {
        //中
    GPSDifference   = @"GPS（中）";
    }
    else
    {
        //差
    GPSDifference   = @"GPS（差）";
    }

    //GPS
    [self setValue:GPSDifference forKey:@"GPSDifference"];
    //speed速度-3
//    [self setValue:[NSString stringWithFormat:@"%.3f",locationSpeed] forKey:@"locationSpeed"];
    
    
    
//    if (_isStopRunning == YES) {
//        
//        [self addLine:userLocation.location.coordinate];
//        
////        [self mapViewAddAnnotation:userLocation.location.coordinate title:@"终点"];
//        _isStopRunning = NO;
//        
//        MAMapPoint point1 = MAMapPointForCoordinate(startDistance);
//        MAMapPoint point2 = MAMapPointForCoordinate(userLocation.location.coordinate);
//        //计算跑步距离
//        distance += (MAMetersBetweenMapPoints(point1, point2) / 1000.0);
//        //距离
//        [self setValue:[NSString stringWithFormat:@"%.3f",distance] forKey:@"distance"];
//        //把跑步数据写入表单，跑步总时间，跑步总距离
//        [self saveMapRunData];
//        
//        
//    }
    
    
    if (!_isStartRunning && userLocation.location.horizontalAccuracy < 70){
        _isStartRunning = YES;
        //改变定位更新距离
        [self changeLocationUpdate];
        //画线开始位置
        startLocation = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        //计算距离开始位置
        startDistance = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        //设置起点
        [self mapViewAddAnnotation:userLocation.location.coordinate title:@"起点"];
    }else{
        //当GPS信号强的时候记录画线
        if (userLocation.location.horizontalAccuracy < 70)
        {
            //移动速度
            if (userLocation.location.speed >= 0 && userLocation.coordinate.latitude != 0 && userLocation.coordinate.longitude != 0)
            {
                
                
                MAMapPoint point1 = MAMapPointForCoordinate(startDistance);
                MAMapPoint point2 = MAMapPointForCoordinate(userLocation.location.coordinate);
                double between = MAMetersBetweenMapPoints(point1, point2);
                //计算跑步距离
                distance += (between / 1000.0);
                //距离
                [self setValue:[NSString stringWithFormat:@"%.3f",distance] forKey:@"distance"];
                startDistance = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
                
                
                //每过10米画一次线
                if (distance >= sign)
                {
                    [self addLine:userLocation.location.coordinate];
                    
                    //画线完成记录当前位置，作为下一次画线的起点
                    startLocation = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
                    //把GPS坐标写入表单，经纬度
                    [self saveMapGPSDataLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                    sign += 0.01;
                }
                
                //每过1000米记录一次
                if (distance > mileMeter)
                {
                    //跑步分段：每一公里存一次数据，段数，这一公里所用的时间
                    [self saveMapRunNumData];
                    startTime = _totalTime.text;
                    mileMeter += 1;
                }
                
            }
            
        }
        
    }
    
}


#pragma mark - 添加起点、终点
- (void)mapViewAddAnnotation:(CLLocationCoordinate2D)location title:(NSString *)title
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = location;
    pointAnnotation.title = title;
    //    pointAnnotation.subtitle = @"";
    //向地图窗口添加标注，需要实现MAMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
    [_mapView addAnnotation:pointAnnotation];
    
    //终点标注
//    if ([title isEqualToString:@"终点"]) {
//        endAnnotation = [[MAPointAnnotation alloc] init];
//        endAnnotation = pointAnnotation;
//    }
    
    
}

//移除终点标注
//- (void)removePointAnnotation
//{
//    [_mapView removeAnnotation:point];
//    
//}

//根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
//        if (_isStopRunning == YES) {
//            annotationView.image = [UIImage imageNamed:@"map_结束"];
//        }else{
//           annotationView.image = [UIImage imageNamed:@"map_开始"];
//        }
        annotationView.image = [UIImage imageNamed:@"map_开始"];
        //设置气泡可以弹出，默认为NO
        annotationView.canShowCallout = YES;
        //设置标注动画显示，默认为NO
        //        annotationView.animatesDrop = YES;
        //设置标注可以拖动，默认为NO
        //        annotationView.draggable = YES;
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

#pragma  mark - 绘制路线
-(void)addLine:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D commonPolylineCoords[2];
    commonPolylineCoords[0] = startLocation;
    commonPolylineCoords[1] = location;
    MAPolyline *commonPolyLine = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
    [_mapView addOverlay:commonPolyLine];
}


- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 8.f;
        polylineView.strokeColor = RGBA(252, 145, 53, 1);
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.lineCap = kCGLineCapRound;
        
        return polylineView;
    }
    return nil;
    
}



#pragma mark - 收藏
- (IBAction)collectionEvent:(UIButton *)sender {
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(MapViewDelegate)]) {
        
        [self.delegate collectionSong:sender];
    }
}

//下一曲
- (IBAction)nextSongEvent:(UIButton *)sender {
    
    if (isnextButton == YES) {
        return;
    }
    isnextButton = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nextSong" object:nil];
    [self performSelector:@selector(todoSomething) withObject:sender afterDelay:2];
}

- (void)todoSomething {
    
    isnextButton = NO;
}

#pragma mark - 保存数据
//把跑步数据写入表单，跑步总时间，跑步总距离
- (void)saveMapRunData
{
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"INSERT INTO Run ('time','distance') VALUES (?,?)",[NSString stringWithFormat:@"%ld",[NSString secondsWithString:_totalTime.text] * 1000],[NSString stringWithFormat:@"%.2f",distance]];
        
    }];
}

//跑步分段：每一公里存一次数据，段数，这一公里所用的时间
- (void)saveMapRunNumData
{
    
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        NSInteger totalTime = [NSString secondsWithString:_totalTime.text];
        NSInteger start     = [NSString secondsWithString:startTime];
        
        [db executeUpdate:@"INSERT INTO RunNum ('number','time') VALUES (?,?)",[NSString stringWithFormat:@"%ld",mileMeter], [NSString stringWithFormat:@"%ld",(totalTime - start) * 1000]];
    }];
}

//GPS坐标：经纬度
- (void)saveMapGPSDataLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
       
        [db executeUpdate:@"INSERT INTO GPS ('latitude','longitude') VALUES (?,?)",[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude]];
    }];
}


#pragma mark - 通知跑步结束再保存一次数据
- (void)endRunSaveMapRunNumData
{
    if (mileMeter == 0) {
        mileMeter++;
    }
    [self saveMapRunData];
    [self saveMapRunNumData];
    
}

#pragma mark - 其他
//代理：显示歌曲界面
- (IBAction)showSongViewTapEvent:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(MapViewDelegate)]) {
        [self.delegate showSongView];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


@end
