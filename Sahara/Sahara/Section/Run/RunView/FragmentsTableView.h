//
//  FragmentsTableView.h
//  Sahara
//
//  Created by huangcan on 15/12/22.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunFragementCell.h"
@interface FragmentsTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger maxTime;
}
@property (nonatomic,strong) NSMutableArray * dataArray;// 每组的数据

- (void)loadTableViewData;

@end
