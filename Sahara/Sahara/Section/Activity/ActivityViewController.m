//
//  ActivityViewController.m
//  Sahara
//
//  Created by huangcan on 15/12/2.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityDetailViewController.h"

#import "ActivityTableViewCell.h"

#import <MJRefresh.h>

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSUInteger _indexPage;
}
@property (weak, nonatomic) IBOutlet UITableView *activityTableView;

@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation ActivityViewController

- (void)viewDidLayoutSubviews {
    
    [_activityTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addCustomNavBarTitle:@"活动" leftBar:nil rigthBar:nil whetherAddBackBar:NO];
    
    _dataArray = [[NSMutableArray alloc]init];
    _activityTableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
    [_activityTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _activityTableView.mj_header.automaticallyChangeAlpha = YES;
    _activityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _activityTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 变为没有更多数据的状态
    [self.activityTableView.mj_footer endRefreshingWithNoMoreData];
    
    [self loadNewData];
}

- (void)loadNewData {
    _indexPage = 1;
    [_dataArray removeAllObjects];
    [self postData];
}

- (void)loadMoreData {
    
    _indexPage ++;
    [self postData];
}

- (void)postData {
    
    [RequestManager PostUrl:URI_RUN_ARTICLEGETACTITYLIST loding:@"获取中..." dic:@{@"pageCount":[NSNumber numberWithUnsignedInteger:_indexPage],@"count":@"10"} isToken:NO response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3){
            if ([response[@"ReturnData"] count] == 0) {
                
                [_activityTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_dataArray addObjectsFromArray:response[@"ReturnData"]];
                [_activityTableView.mj_footer endRefreshing];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
            
            [_activityTableView.mj_footer endRefreshing];
        }
        [_activityTableView.mj_header endRefreshing];
        
        [_activityTableView reloadData];
    }];
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"ActivityTableViewCell";
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell)
    {
        UINib * nib = [UINib nibWithNibName:[ActivityTableViewCell description] bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:Identifier];
        cell        = [tableView dequeueReusableCellWithIdentifier:Identifier];
    }
    //数据
    [cell loadCellData:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActivityDetailViewController * detailVC = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:[NSBundle mainBundle]];
    detailVC.detailDic = _dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
