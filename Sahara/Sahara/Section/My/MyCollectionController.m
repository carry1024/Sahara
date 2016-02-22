//
//  MyCollectionController.m
//  Sahara
//
//  Created by heng on 16/1/8.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "MyCollectionController.h"

@interface MyCollectionController ()

@end

@implementation MyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _withoutLabel.hidden = YES;
    _tableView.dataArray = [NSMutableArray array];

    [_tableView loadTableViewData];
    [self getSunData];
    //    _tableVie
    [self addCustomNavBarTitle:@"我的收藏" leftBar:nil rigthBar:nil whetherAddBackBar:YES];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(delede:) name:@"delede" object:nil];
}


//删除歌曲
- (void)delede:(NSNotification *)info {
    
    NSDictionary * dict = info.userInfo;
    
    NSIndexPath * index = dict[@"indexPath"];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:(index.row - 1) inSection:index.section];
    [RequestManager PostUrl:URI_RUN_SONGDELSONGLIKE loding:@"正在删除..." dic:@{@"contentId":dict[@"songId"]} isToken:YES response:^(id response) {
        if ([response[@"ReturnCode"] integerValue] == 3) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            
            
            [_tableView.dataArray removeObjectAtIndex :index. row ];
            [_tableView.dataArray removeObjectAtIndex :indexPath.row ];
            
            [self.tableView beginUpdates ];
            [self.tableView deleteRowsAtIndexPaths: @[index,indexPath] withRowAnimation: UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
            
            [self.tableView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response[@"ReturnMsg"]]];
        }
    }];
}
//获取数据
-(void)getSunData{
    [RequestManager PostUrl:URI_RUN_GetMyFavorite  loding:@"正在加载.." dic:nil isToken:YES response:^(id response) {
        
        if ([response[@"ReturnCode"] integerValue] == 3) {
            if ([response[@"ReturnData"] isEqual:[NSNull null]] || response[@"ReturnData"] == nil) {
                _tableView.dataArray = [NSMutableArray mutableCopy];
                _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] init];
                _withoutLabel.hidden = NO;
                return ;
            }
            _tableView.dataArray = [response[@"ReturnData"] mutableCopy];
            [_tableView loadTableViewData];
        }else{
            
//            [SVProgressHUD showErrorWithStatus:response[@"ReturnMsg"]];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
