//
//  RunSaveController.m
//  Sahara
//
//  Created by huangcan on 15/12/16.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunSaveController.h"
#import "ExpandTableView.h"
#import "FragmentsTableView.h"
#import "MapSaveView.h"
#import "FMDB_Help.h"
#import "NSString+FSExtension.h"
#import "RunRecordViewController.h"
#import "ImageSaveLocal.h"
#import "ShareCustom.h"

#import <ShareSDK/ShareSDK.h>

@interface RunSaveController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (strong, nonatomic) IBOutlet ExpandTableView *songTable;
@property (strong, nonatomic) IBOutlet FragmentsTableView *fragmentTable;
@property (weak, nonatomic) IBOutlet UIView *mapSaveDataView;
@property (strong, nonatomic)MapSaveView *mapSaveView;
//跑步数据
@property (nonatomic, strong) NSMutableDictionary *runDataDic;
//跑步段数数据
@property (nonatomic, strong) NSMutableArray *runNumDataArray;
//歌曲数据
@property (nonatomic, strong) NSMutableArray *musicDataArray;
//GPS数据
@property (nonatomic, strong) NSMutableArray *GPSDataArray;
@end

@implementation RunSaveController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIButton * rightBtn = [[UIButton alloc]init];
//    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setImage:[UIImage imageNamed:@"share-ic"] forState:UIControlStateNormal];
    
    
    [self addCustomNavBarTitle:@"储存" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    
    [_shareButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _segmented.tintColor = MAINCOLOR;
    
    
    _mapSaveView = [[MapSaveView alloc] init];
    _mapSaveView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    [_mapSaveDataView addSubview:_mapSaveView];
    [self runningDetails];
    if (_isRunDetails == YES) {
        
    }else{
//        [self takeMapGPSData];
//        [self takeMapRunData];
//        [self takeMapRunNumData];
//        [self takeMusicData];
    }
    
    
}

-(void)viewWillLayoutSubviews {
    
//    _mapSaveView.frame = CGRectMake(0, 0, _mapSaveDataView.bounds.size.width, _mapSaveDataView.bounds.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segementBtnAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            _mapSaveView.hidden = NO;
            _songTable.hidden = YES;
            _fragmentTable.hidden = YES;
            break;
        case 1:
            _mapSaveView.hidden = YES;
            _songTable.hidden = NO;
            _fragmentTable.hidden = YES;
            break;
        case 2:
            _mapSaveView.hidden = YES;
            _songTable.hidden = YES;
            _fragmentTable.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)popViewConDelay
{
    if (_isRunDetails == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)leftBtnAction:(UIButton *)sender {
    
    if (_isRunDetails == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


- (void)rightBtnAction:(UIButton *)sender {
    
    //地图截图
    CGRect inRect = CGRectMake(0, 20, ScreenWidth, ScreenHeight);
    UIImage *screenshotImage = [_mapSaveView.mapView takeSnapshotInRect:inRect];
    //保存到本地沙盒
    [ImageSaveLocal saveImage:screenshotImage withFileName:@"地图" ofType:@"png"];
    //图片
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[ImageSaveLocal takePathWithFileName:@"地图" ofType:@"png"]];
    
    //距离
    NSString *distance;
    //时间
    NSString *time;
    //歌曲
    NSInteger index;
    //地址
    NSString *url = [NSString stringWithFormat:@"%@?RunId=%@",SHAREURL,_runId];
    
    if (_runDataDic.count == 0) {
        distance = @"0";
        time = @"00 : 00 : 00";
    }else{
        distance = _runDataDic[@"distance"];
        time = [NSString stringWithSeconds:[_runDataDic[@"time"] integerValue] / 1000 isHours:YES];
    }
    
    if (_musicDataArray.count == 0) {
        index = 0;
    }else{
        index = _musicDataArray.count;
    }
    //标题
    NSString *title = [NSString stringWithFormat:@"撒哈拉陪我跑了%@公里，我听了%ld首歌",distance,index];
    
    //内容
    NSString *content = [NSString stringWithFormat:@"跑步：%@公里\n用时：%@\n听了：%ld首歌",distance,time,index];
    
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:nil image:localAttachment title:title url:url description:nil mediaType:SSPublishContentMediaTypeNews];
    
    
    //内容
    NSString *woboContent = [NSString stringWithFormat:@"跑步：%@公里\n用时：%@\n听了：%ld首歌\n%@",distance,time,index,url];
    id<ISSContent> woboPublishContent = [ShareSDK content:woboContent defaultContent:nil image:localAttachment title:title url:url description:nil mediaType:SSPublishContentMediaTypeNews];
    
     [ShareCustom shareWithContent:publishContent woboContent:woboPublishContent];
    
    
    /*
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    
    //2、展现分享菜单
    NSArray *shareList = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:ShareTypeSinaWeibo],[NSNumber numberWithInt:ShareTypeWeixiSession],[NSNumber numberWithInt:ShareTypeQQ],[NSNumber numberWithInt:ShareTypeWeixiTimeline], nil];
    
//    [ShareSDK showShareViewWithType:ShareTypeWeixiSession container:container content:publishContent statusBarTips:YES authOptions:nil shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//        
//    }];
    
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"错误描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"确定"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
    */
    
    
}

//上传跑步数据到后台
//- (IBAction)saveRunDataEvent:(id)sender {
//    
//
//    if ([_runDataDic[@"distance"] floatValue] <= 0.2) {
//        [SVProgressHUD showInfoWithStatus:@"你跑步的距离小于200米,不能保存"];
//        return;
//    }
//    
//    //更新歌曲数据
//    [_songTable.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj[@"Cell"] isEqualToString:@"AttachedCell"]) {
//            [_songTable.dataArray removeObjectAtIndex:idx];
//        }
//    }];
//    _musicDataArray = _songTable.dataArray;
//    
//    NSDictionary *dic = @{@"run":_runDataDic,@"runNum":_runNumDataArray,@"music":_musicDataArray,@"gps":_GPSDataArray};
//    NSString * data = [RequestManager JsonStr:dic];
//    
//    [RequestManager PostUrl:URI_RUN_MOVEMENTPUSHRUNDATA loding:@"保存中..." dic:@{@"data":data} isToken:YES response:^(id response) {
//        if ([response[@"ReturnCode"] integerValue] == 3) {
//            
//            //更新跑步数据
//            NSNotification * notice = [NSNotification notificationWithName:KNOTIFICATION_RUNRELOADDATA object:nil userInfo:nil];
//            //发送消息
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//            //在本地数据库中删除本次跑步数据
//            [self clearAllRunData];
//            [SVProgressHUD showSuccessWithStatus:@"成功"];
//            
//            RunRecordViewController *runRecordVC = [[RunRecordViewController alloc] init];
//            runRecordVC.isRunSaveDataInterface = YES;
//            [self.navigationController pushViewController:runRecordVC animated:YES];
//        }else {
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
//        }
//    }];
//
//}

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
        
        NSLog(@"%@",_runDataDic);
        [self calculateTheRunningData:_runDataDic];
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
        
        NSLog(@"%@",_runNumDataArray);
        //数据
        _fragmentTable.dataArray = [_runNumDataArray copy];
        //加载数据
        [_fragmentTable loadTableViewData];
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
        NSLog(@"%@",_musicDataArray);
        //数据
        _songTable.dataArray = [_musicDataArray copy];
        //加载数据
        [_songTable loadTableViewData];
        
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
        NSLog(@"%@",_GPSDataArray);
        [_mapSaveView addLineGPSArray:_GPSDataArray];
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


#pragma mark - 计算跑步数据
- (void)calculateTheRunningData:(NSMutableDictionary *)data
{
    CGFloat weight                 = [[UserData UserDefaults:@"Weight"] floatValue];
    CGFloat distance               = [data[@"distance"] floatValue];
    NSInteger time                 = [data[@"time"] integerValue];
    //距离
    _mapSaveView.saveDistance.text = [NSString stringWithFormat:@"%.2f",distance];
    self.runNumDistance.text       = _mapSaveView.saveDistance.text;

    //时间
    _mapSaveView.saveTime.text     = [NSString stringWithSeconds:(time / 1000) isHours:YES];
    self.runNumTime.text           = _mapSaveView.saveTime.text;
    
    //配速
    if (distance == 0) {
        _mapSaveView.saveSpeed.text    = @"0'00''";
        self.runNumSpeed.text          = _mapSaveView.saveSpeed.text;
        
    } else {
        
        NSInteger minute    = (NSInteger)time/1000/distance/60;
        NSInteger minuteInt = (NSInteger)time/1000/distance/60 * 100;
        NSInteger decimal   = 0;
        if (minute != 0) {
            decimal = (NSInteger)minuteInt % (minute * 100);
        } else {
            decimal = minuteInt;
        }
        if (decimal == 0) {
            _mapSaveView.saveSpeed.text = [NSString stringWithFormat:@"%ld'00''",minute];
            self.runNumSpeed.text       = _mapSaveView.saveSpeed.text;
        }else{
            
            int times = (int)floor(decimal * 0.6);
            if (times < 10) {
                _mapSaveView.saveSpeed.text = [NSString stringWithFormat:@"%ld'0%d''",minute,times];
                self.runNumSpeed.text       = _mapSaveView.saveSpeed.text;
            }else{
                _mapSaveView.saveSpeed.text = [NSString stringWithFormat:@"%ld'%d''",minute,times];
                self.runNumSpeed.text       = _mapSaveView.saveSpeed.text;
            }
            
        }
        
//        _mapSaveView.saveSpeed.text    = [NSString stringWithFormat:@"%.1f",[data[@"time"] integerValue] / 1000 / distance / 60];
//        self.runNumSpeed.text          = _mapSaveView.saveSpeed.text;
        
    }
    
    
    //卡路里
    _mapSaveView.saveCalories.text = [NSString stringWithFormat:@"%.1f",weight * distance * 1.036f];
    self.runNumCalories.text       = _mapSaveView.saveCalories.text;
    
}

- (void)runningDetails
{
    
    _runDataDic = [[NSMutableDictionary alloc] init];
    _musicDataArray = [[NSMutableArray alloc] init];
    //网络请求
    [RequestManager PostUrl:URI_RUN_GetRunDetails loding:nil dic:@{@"runId":_runId} isToken:YES response:^(id response) {
        

        if ([response[@"ReturnCode"] integerValue] == 3) {
            id data = [response[@"ReturnData"] objectFromJSONString];
            [self calculateTheRunningData:data[@"run"]];
            
            //数据
            _fragmentTable.dataArray = [data[@"runNum"] copy];
            //加载数据
            [_fragmentTable loadTableViewData];
            
            //数据
            _songTable.dataArray = [data[@"music"] copy];
            //加载数据
            [_songTable loadTableViewData];
            
            [_mapSaveView addLineGPSArray:data[@"gps"]];
            
            _runDataDic = [data[@"run"] copy];
            _musicDataArray = [data[@"music"] copy];
            return;
        }else{
            
            return;
        }
        
    }];
}




- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_RUNRELOADDATA object:nil];
    
}



@end
