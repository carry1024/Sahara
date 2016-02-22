//
//  SongToolCell.h
//  Sahara
//
//  Created by huangcan on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一个协议
@protocol SongToolCellDelegate <NSObject>

- (void)toolCellCollection:(UIButton *)sender;
@end

@interface SongToolCell : UITableViewCell

@property (strong, nonatomic) id<SongToolCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic, strong)NSString * songId;

- (void)loadCellDic:(NSDictionary *)dic;

@end
