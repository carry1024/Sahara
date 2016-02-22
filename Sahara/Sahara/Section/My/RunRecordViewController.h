//
//  RunRecordViewController.h
//  Sahara
//
//  Created by heng on 15/12/17.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "FatherViewController.h"

@interface RunRecordViewController : FatherViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *record;

/**
 *  是否是从跑步完成保存数据后push过来的
 */
@property (nonatomic) BOOL isRunSaveDataInterface;

@property (strong, nonatomic) IBOutlet UILabel *withoutLabel;

@end
