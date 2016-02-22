//
//  CollectionSaveCell.h
//  Sahara
//
//  Created by heng on 15/12/24.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
//协议定义
@protocol CollectionSaveDelegate <NSObject>

- (void)insertRowDelegate:(UIButton *)sender;

@end

@interface CollectionSaveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (nonatomic,assign) id<CollectionSaveDelegate>delegate;
- (void)loadCellData:(NSDictionary *)dic;
@end
