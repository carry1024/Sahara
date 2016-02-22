//
//  MyCollectionTableView.h
//  Sahara
//
//  Created by heng on 16/1/5.
//  Copyright © 2016年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionToolCell.h"
#import "CollectionSaveCell.h"
@interface MyCollectionTableView : UITableView<UITableViewDataSource,UITableViewDelegate,CollectionSaveDelegate>
{
    BOOL _isShow;// 组的状态，yes显示组，no不显示组
    NSIndexPath *_Openpath;//打开关闭的位置
}

@property (nonatomic, strong)NSMutableArray * dataArray;// 每组的数据

- (void)loadTableViewData;


@end
