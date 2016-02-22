//
//  MapSaveView.m
//  Sahara
//
//  Created by junzong on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "MapSaveView.h"


@interface MapSaveView ()<MAMapViewDelegate>
{
    //跑步结束
    BOOL _isStopRunning;
}

@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableArray *showAnnotationArray;

@end


@implementation MapSaveView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MapSaveView" owner:self options:nil] firstObject];
        [self loadInterface];
    }
    return self;
}

- (void)loadInterface
{
    _mapView.delegate = self;
    //缩放级别
//    [_mapView setZoomLevel:16.1 animated:YES];
    //是否显示罗盘，默认为YES
    _mapView.showsCompass = NO;
    //是否显示比例尺，默认为YES
    _mapView.showsScale = NO;
 
}



- (void)addLineGPSArray:(NSMutableArray *)array
{
    NSArray *mark = @[@"起点",@"终点"];
    _annotationArray = [NSMutableArray array];
    _showAnnotationArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        
        CLLocationCoordinate2D currLocation = {[array[i][@"latitude"] doubleValue],[array[i][@"longitude"] doubleValue]};
        
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = currLocation;
        [_showAnnotationArray addObject:pointAnnotation];
        
        if (i == 0) {
            pointAnnotation.title = mark[0];
            [_annotationArray addObject:pointAnnotation];
            
        }
        

        if (i == array.count - 1) {
            pointAnnotation.title = mark[1];
            [_annotationArray addObject:pointAnnotation];
            [_mapView addAnnotations:_annotationArray];
        }
        
        if (i < array.count - 1) {
            CLLocationCoordinate2D startLocation = {[array[i][@"latitude"] doubleValue],[array[i][@"longitude"] doubleValue]};
            CLLocationCoordinate2D endLocation = {[array[i + 1][@"latitude"] doubleValue],[array[i + 1][@"longitude"] doubleValue]};
            
            [self addLineStartLocation:startLocation endLocation:endLocation];
        }
        
    }
    
    [_mapView showAnnotations:_showAnnotationArray animated:YES];
    
}


//根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        if ([annotation.title isEqualToString:@"起点"]) {
            annotationView.image = [UIImage imageNamed:@"map_开始"];
        }else if ([annotation.title isEqualToString:@"终点"]){
            annotationView.image = [UIImage imageNamed:@"map_结束"];
        }
        
        
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

//绘制路线
-(void)addLineStartLocation:(CLLocationCoordinate2D)startLocation endLocation:(CLLocationCoordinate2D)endLocation
{
    CLLocationCoordinate2D commonPolylineCoords[2];
    commonPolylineCoords[0] = startLocation;
    commonPolylineCoords[1] = endLocation;
    MAPolyline *commonPolyLine = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:2];
    [_mapView addOverlay:commonPolyLine];
}



- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 8.f;
//        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.strokeColor = RGBA(252, 145, 53, 1);
        polylineView.lineJoin = kCGLineJoinRound;
        polylineView.lineCap = kCGLineCapRound;
        
        return polylineView;
    }
    return nil;
    
}


@end
