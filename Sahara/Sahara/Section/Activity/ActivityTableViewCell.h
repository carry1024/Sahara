//
//  ActivityTableViewCell.h
//  Sahara
//
//  Created by heng on 15/12/11.
//  Copyright © 2015年 bode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityState;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
@property (weak, nonatomic) IBOutlet UILabel *activityPeopleNumber;
@property (strong, nonatomic) IBOutlet UIImageView *activityCover;


- (void)loadCellData:(NSDictionary *)dic;

@end
