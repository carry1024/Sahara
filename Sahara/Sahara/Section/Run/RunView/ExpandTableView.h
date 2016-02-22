//
//  ExpandTableView.h
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SongSaveCell.h"
#import "SongToolCell.h"

@interface ExpandTableView : UITableView<UITableViewDataSource,UITableViewDelegate,SongToolCellDelegate/*SongSaveCellDelegate*/>
{
    BOOL _isShow;// 组的状态，yes显示组，no不显示组
    NSIndexPath *_Openpath;//打开关闭的位置
}

@property (nonatomic, strong)NSMutableArray * dataArray;// 每组的数据

- (void)loadTableViewData;
@end

