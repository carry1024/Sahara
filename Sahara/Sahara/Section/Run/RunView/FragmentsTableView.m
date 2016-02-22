//
//  FragmentsTableView.m
//  Sahara
//
//  Created by huangcan on 15/12/22.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FragmentsTableView.h"
#import "NSString+FSExtension.h"

@implementation FragmentsTableView


- (void)loadTableViewData {
    maxTime = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        NSInteger currTime = [_dataArray[i][@"time"] integerValue];
        maxTime = currTime > maxTime ? currTime : maxTime;
    }
    self.delegate =self;
    self.dataSource =self;
    [self reloadData];
}
#pragma mark -- Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.rowHeight;
}
// 添加每行显示的内容
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RunFragementCell";
    RunFragementCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (!cell) {
        UINib * nib = [UINib nibWithNibName:@"RunFragementCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:@"RunFragementCell"];
        cell        = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (_dataArray.count != 0) {
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
//        cell.timeLabel.text = [NSString stringWithFormat:@"%ld",[_dataArray[indexPath.row][@"data"] integerValue] / 1000];
        cell.timeLabel.text = [NSString stringWithSeconds:([_dataArray[indexPath.row][@"time"] integerValue] / 1000) isHours:NO];
        [cell loadCellData:_dataArray[indexPath.row]];
        cell.maxTime = maxTime;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UILabel * distanceLabel = [[UILabel alloc]init];
    distanceLabel.center = CGPointMake(20, 18);
    distanceLabel.bounds = CGRectMake(0, 0, 30, 15);
    distanceLabel.font = [UIFont systemFontOfSize:15];
    distanceLabel.textColor = RGBA(248, 142, 66, 1);
    distanceLabel.text = @"公里";
    
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"save_时间-ic"]];
    imgView.center = CGPointMake(60, 18);
    
    [sectionView addSubview:imgView];
    [sectionView addSubview:distanceLabel];
    return sectionView;
}

@end
