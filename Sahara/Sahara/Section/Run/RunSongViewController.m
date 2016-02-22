//
//  RunSongViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/9.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunSongViewController.h"

#import "RunSongCell.h"
#import "RuningViewController.h"
#import "RootBarController.h"

#import "FMDB_Help.h"

static NSString * CellIdentifier = @"RunSongCell";

@interface RunSongViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray * runDataArr;
@end

@implementation RunSongViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((RootBarController *)self.tabBarController).rootBarView.hidden = YES;
    //删除跑步数据
    [self clearAllRunData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavBarTitle:@"歌单" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINib * cellNib = [UINib nibWithNibName:@"RunSongCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    [self loadInfoData];
}

- (void)loadInfoData {
    
    [RequestManager PostUrl:URI_RUN_GETPLAYLISTS loding:@"加载歌单" dic:@{@"pageCount":@"1",@"count":@"100"}  isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            _runDataArr = [NSArray arrayWithArray:response[@"ReturnData"]];
            
            [self.collectionView reloadData];
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"获取失败，请重新获取歌曲！"];
        }
    }];
    
}

#pragma mark  删除数据
- (void)clearAllRunData
{
    [[FMDB_Help sharedInstance] inDatabase:^(FMDatabase *db) {
        
        BOOL run = [db executeUpdate:@"DELETE FROM Run"];
        BOOL runNum = [db executeUpdate:@"DELETE FROM RunNum"];
        BOOL music = [db executeUpdate:@"DELETE FROM Music"];
        BOOL gps = [db executeUpdate:@"DELETE FROM GPS"];
        
        if (run && runNum && music && gps) {
            NSLog(@"数据库数据删除成功");
        }else{
            NSLog(@"数据库数据删除失败");
        }
    }];
}

#pragma mark -- UICollectionViewDataSource 

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _runDataArr.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RunSongCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //数据
    [cell loadCellInfo:_runDataArr[indexPath.row]];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 7;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/2 -18, ScreenWidth/2 -18);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 主线程执行：
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [RequestManager PostUrl:URI_RUN_GETSONGLISTBYPLAYID loding:@"加载中..." dic:@{@"playId":_runDataArr[indexPath.row][@"Id"]} isToken:YES response:^(id response) {
            
            if ([response[@"ReturnCode"] integerValue] == 3) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (![response[@"ReturnData"] isEqual:[NSNull null]]) {
                        RuningViewController * runingSong = [[RuningViewController alloc]initWithNibName:@"RuningViewController" bundle:[NSBundle mainBundle]];
                        runingSong.songArr = [NSArray arrayWithArray:response[@"ReturnData"]];
                        [self.navigationController pushViewController:runingSong animated:YES];
                    } else {
                        [SVProgressHUD showInfoWithStatus:@"此歌单无歌曲，请重新选择歌单"];
                        //                    runingSong.songArr = [NSArray array];
                    }
                    
                });
            } else {
                [SVProgressHUD showErrorWithStatus:@"歌曲请求失败，请重试"];
            }
        }];
    });
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
