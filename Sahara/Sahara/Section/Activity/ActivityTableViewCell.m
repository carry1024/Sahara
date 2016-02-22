//
//  ActivityTableViewCell.m
//  Sahara
//
//  Created by heng on 15/12/11.
//  Copyright © 2015年 bode. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "NSString+FSExtension.h"
#import "NSDate+FSExtension.h"
@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadCellData:(NSDictionary *)dic {
    NSDate * nowDate = [NSDate date];
    
    //活动开始
    NSDate * BeginTime = [[dic[@"BeginTime"]fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"] laterDate:nowDate];
    NSDate * EndTime = [[dic[@"EndTime"]fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"] earlierDate:nowDate];
    if ([dic[@"IsActivity"] boolValue] == YES) {
        _activityState.image = [UIImage imageNamed:@"Activity_状态标签(报名)-ic"];
    }
    if ([BeginTime isEqualToDate:nowDate] && [EndTime isEqualToDate:nowDate]) {
        
        _activityState.image = [UIImage imageNamed:@"Activity_状态标签(进行)-ic"];
    } else {
        _activityState.image = [UIImage imageNamed:@"Activity_状态标签(结束)-ic"];
    }
    
    NSDate * JoinBeginTime = [[dic[@"JoinBeginTime"]fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"] laterDate:nowDate];
    NSDate * JoinEndTime = [[dic[@"JoinEndTime"]fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"] earlierDate:nowDate];
    //活动报名开始
    if ([JoinBeginTime isEqualToDate:nowDate] && [JoinEndTime isEqualToDate:nowDate]) {
        _activityState.image = [UIImage imageNamed:@"Activity_状态标签(报名)-ic"];
    }
    
    _activityName.text = [NSString stringWithFormat:@"%@",dic[@"Title"]];
    _activityAddress.text = [NSString stringWithFormat:@"%@",dic[@"Locale"]];
    _activityPeopleNumber.text = [NSString stringWithFormat:@"%@人",dic[@"JoinCount"]];
    _activityTime.text = [NSString stringWithFormat:@"%@",
                          [[dic[@"BeginTime"]fs_dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"] fs_stringWithFormat:@"yyyy年/MM月/dd"]];
    [_activityCover sd_setImageWithURL:dic[@"Cover"] placeholderImage:[UIImage imageNamed:@"Ac填充测试图"]];
    _activityCover.clipsToBounds = YES;
}


@end
