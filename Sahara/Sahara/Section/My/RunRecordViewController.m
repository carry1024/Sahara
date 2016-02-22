//
//  RunRecordViewController.m
//  Sahara
//
//  Created by heng on 15/12/17.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "RunRecordViewController.h"
#import "RunRecordTableViewCell.h"
#import "HeaderView.h"
#import "NSDate+FSExtension.h"
#import "NSString+FSExtension.h"
#import "RunSaveController.h"
@interface RunRecordViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableDictionary * _dataDic;
    NSMutableArray *_arrayData;
}

@end

@implementation RunRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _withoutLabel.hidden = YES;
    _dataDic = [[NSMutableDictionary alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _arrayData = [[NSMutableArray alloc] init];
    [self addCustomNavBarTitle:@"跑步记录" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 设置分割线样式
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getDataW];
    
}

- (void)getDataW{
    //网络请求
    [RequestManager PostUrl:URI_RUN_GetRunList loding:@"正在加载.." dic:@{@"count":@"100", @"pageCount":@"1"} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            _record = response[@"ReturnData"];
            if (_record.count == 0) {
                _withoutLabel.hidden = NO;
            }
            [self loadData:_record];
            return;
        }else{
            return;
        }
        
    }];
}
- (void)loadData:(NSArray *)dataArr {

    _dataDic = [[NSMutableDictionary alloc]init];
    __block NSMutableArray * arr = nil;
    [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        NSString * time = [NSString stringWithFormat:@"%@",obj[@"CreatedTime"]];
        NSDate * date =[time fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS +0008"];
        
        NSString * dicTime = [NSString stringWithFormat:@"%ld-%ld",date.fs_year,date.fs_month];
    
        if (idx == 0) {
            
            arr = [NSMutableArray arrayWithObject:obj];
            
            [_dataDic setObject:arr forKey:dicTime];
        } else {
            
            NSString * onTime = [NSString stringWithFormat:@"%@",_record[idx-1][@"CreatedTime"]];
            NSDate * onDate =[onTime fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS +0008"];
            
            NSString * onDicTime = [NSString stringWithFormat:@"%ld-%ld",onDate.fs_year,onDate.fs_month];
            
            if ([onDicTime isEqualToString:dicTime]) {
                
                [arr addObject:obj];
                [_dataDic setObject:arr forKey:dicTime];
            } else {
                [_dataDic setObject:arr forKey:onDicTime];
                
                arr = [NSMutableArray arrayWithObject:obj];
            }
        }
    }];
    for (NSArray *arr in [_dataDic allValues]) {
        [_arrayData addObject:arr];
    }
    for (int i = 0; i<_arrayData.count/2.0; i++) {
        
        [_arrayData exchangeObjectAtIndex:i withObjectAtIndex:_arrayData.count-1-i];
        
    }
    
    [_tableView reloadData];
   
}
#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_arrayData[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView  *headerView  = [[[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil] firstObject];
    headerView.month.text = [NSString stringWithFormat:@"%@月", [_arrayData[section][0][@"CreatedTime"] substringWithRange:NSMakeRange(5, 2)]];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:now];
    NSString *nowYe = [NSString stringWithFormat:@"%@", [strDate substringWithRange:NSMakeRange(0, 4)]];
    NSString *allYeaer = [_arrayData[section][0][@"CreatedTime"] substringWithRange:NSMakeRange(0, 4)];
    
    if (![allYeaer  isEqualToString: nowYe]) {
        headerView.yeaer.text = [NSString stringWithFormat:@"(%@年)", allYeaer];
    }
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 24;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"RunRecordTableViewCell";
    RunRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RunRecordTableViewCell" owner:nil options:nil].firstObject;
    }
    //月日、时分
    NSString *strMonth = _arrayData[indexPath.section][indexPath.row][@"CreatedTime"];
    cell.monthDay.text = [NSString stringWithFormat:@"%@月%@日", [strMonth substringWithRange:NSMakeRange(5, 2)], [strMonth substringWithRange:NSMakeRange(8, 2)]];
    cell.hoursMinutes.text = [NSString stringWithFormat:@"%@", [strMonth substringWithRange:NSMakeRange(11, 5)]];

    cell.andTime.text = [NSString stringWithSeconds:([_arrayData[indexPath.section][indexPath.row][@"Time"] integerValue] / 1000) isHours:YES];
    float speedW = [_arrayData[indexPath.section][indexPath.row][@"Distance"] floatValue];
    float time = [_arrayData[indexPath.section][indexPath.row][@"Time"]  floatValue] / 60000 ;
    float a = time /speedW;
    NSLog(@"%f", a);
    cell.speed.text = [NSString stringWithFormat:@"%.2lf", a] ;
    
    //总距离
    cell.andDistance.text = [NSString stringWithFormat:@"%@", _arrayData[indexPath.section][indexPath.row][@"Distance"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *strID = [NSString stringWithFormat:@"%@", _arrayData[indexPath.section][indexPath.row][@"Id"]];
    
    RunSaveController *run = [[RunSaveController alloc] init];
    run.runId = strID;
    run.isRunDetails = YES;
    NSLog(@"%@", strID);
    [self.navigationController pushViewController:run animated:YES];
}


- (void)popViewConDelay
{
    if (_isRunSaveDataInterface == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
