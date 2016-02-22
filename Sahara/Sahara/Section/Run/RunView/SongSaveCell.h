//
//  SongSaveCell.h
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
//协议定义
@protocol SongSaveCellDelegate <NSObject>

- (void)insertRowDelegate:(UIButton *)sender;

@end
*/

@interface SongSaveCell : UITableViewCell 
//@property (nonatomic, strong) id<SongSaveCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *cellNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *songNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *stateBtn;

- (void)loadCellData:(NSDictionary *)dic;
@end
