//
//  RunRecordTableViewCell.h
//  Sahara
//
//  Created by heng on 15/12/21.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *isCancleImage;
@property (weak, nonatomic) IBOutlet UILabel *monthDay;
@property (weak, nonatomic) IBOutlet UILabel *hoursMinutes;

@property (weak, nonatomic) IBOutlet UILabel *andTime;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *andDistance;


@end
