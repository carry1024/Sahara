//
//  MyCollectionController.h
//  Sahara
//
//  Created by heng on 16/1/8.
//  Copyright © 2016年 bode. All rights reserved.
//

#import "FatherViewController.h"
#import "MyCollectionTableView.h"
@interface MyCollectionController : FatherViewController
@property (strong, nonatomic) IBOutlet MyCollectionTableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *withoutLabel;

@end
